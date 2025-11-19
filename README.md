# Multi-Agent Work Allocation System
Note: 
1st implemented using Langgraph + Gemini API + sqlite3 due to familiarity with the stack and to complete the assignment in one way atleast.
Then, upon finishing that tried this approach and in the process learnt Strands Agents. 

## Tech Stack with Justification:
- Python + Strands Agents: Modular multi-agent orchestration framework for clear separation of responsibilities.
- MySQL + PHPMyAdmin + SQLAlchemy: Robust relational database with monitoring and connection pooling support.
- Gemini API + Bedrock LLMs: For generating human-readable explanations of assignment decisions, with fallback logic.
- Docker: To run MySQL and phpmyadmin containers.
- Pandas: For data loading and manipulation from CSV files.

## Setup Instructions
[requirements.txt + docker-compose.yml + work_allocation.sql (phpMyAdmin SQL Dump)]
- Create a virtual environment: `python -m venv .venv`
- Activate (Windows): `.venv/Scripts/activate`
- Install dependencies: `pip install -r requirements.txt`
- Or for faster execution use uv: `uv init`, `uv venv`, `.venv/Scripts/activate`, `uv pip install -r requirements.txt`
- Setup database:
  - Requires MySQL running on port 3307 (default:3306, can edit in docker-compose, .env).
  - Run `docker-compose up -d` from the project root to start MySQL and PHPMyAdmin (monitoring at port 8080).
- Environment variables for database and LLM providers. Check sample .env file below.
- Initialize schema and load CSV data by running `initialize_database(reset=True)`.
- Set to False if you don't want your database to be recreated everytime the script is run.
- Run notebook `demo.ipynb` using the virtual environment kernel for full demonstration.

**Sample .env**
```
# Gemini
GOOGLE_API_KEY=
GEMINI_MODEL=gemini-2.5-flash (I used this model.)
# Bedrock
AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
AWS_DEFAULT_REGION=
BEDROCK_MODEL_ID=anthropic.claude-3-sonnet-20240229-v1:0
# MySQL Database
DB_HOST=localhost
DB_PORT=3307
DB_NAME=work_allocation
DB_USER=work_user
DB_PASSWORD=work_password
```

## Design Decisions and Trade-offs

- Separation of concerns in notebook cells enhances clarity and modular development:
    - Cell 1: All Imports
    - Cell 2: Database Manager (Connection Pooling)
    - Cell 3: Database Helper Functions
    - Cell 4: Tool Functions for Agents (Scoring Logic + Other core logics)
    - Cell 5: LLM Setup with Bedrock Primary + Gemini Fallback
    - Cell 6: 5 Strands Agents 
        Agent 1 - AddWorkAgent: Accepts work request → inserts into database → returns work_id
        Agent 2 - WorkAnalyzerAgent: Analyzes work_id → determines required specialty/role
        Agent 3 - ResourceFinderAgent: Finds resources matching required specialty
        Agent 4 - AvailabilityCheckerAgent: Scores candidates based on availability, workload, skill, experience select best match
        Agent 5 - AssignmentAgent: Updates database + uses LLM to generate explanation of assignment decision
    - Cell 7: Strands Graph Connecting the 5 Agents
    - Cell 8: Initialize Database
    - Cell 9-11: Demonstration of 3 scenerios
- Used few-shot prompting for LLM reasoning to generate assignment explanations.
- Scoring components are modular and tunable according to organizational priorities.
- The agent pipeline approach improves maintainability by separating concerns into distinct agent responsibilities.
- Used PHPmyadmin and MySQL over sqlite3 because of its ease to monitor the database.
- Used fallback LLM model to handle primary model outages.
- Was trying to use Bedrock but turns out it's paid, so used Gemini for Strands Agents however the code is intact for Bedrock.
- For system_prompts in Strands Agents used to the point and short prompts and instructed the LLM to avoid providing any reasoning for the actions taken, to avoid token usage.

### Folder Structure
```
intelligent-work-allocation/
│
├── data/                          # Raw input CSV data files
│   ├── resource_calendar.csv
│   ├── resources.csv
│   ├── specialty_mapping.csv
│   └── work_requests.csv
│
├── diagrams/                      # Architecture and Sequence diagrams
│   ├── ArchitectureDiagram.png
│   └── SequenceDiagram.png
│
├── main.ipynb                    # Main jupyter notebook with agents, tools, demonstrations and database manager.
├── .env                          # Environment variables for DB and APIs
├── work_allocation.sql           # phpmyadmin SQL dump
├── docker-compose.yml            # Docker compose to run containers (MySQL, PHPMyAdmin)
├── requirements.txt              # Python dependencies
├── README.md                     # Project documentation
└── .gitignore                    # Git ignore rules
```
### Diagrams

Architecture Diagram:
<img width="3803" height="1460" alt="ArchitectureDiagram" src="https://github.com/user-attachments/assets/0086b74e-689f-4863-9a76-be2e6b7ba26f" />
Sequence Diagram:
<img width="4190" height="1650" alt="SequenceDiagram" src="https://github.com/user-attachments/assets/120a96af-5970-430d-8b03-8d186349d135" />

## Scoring Logic Rationale

### Base Scoring Framework (100 Points Total)
Structured the scoring to reflect what matters most in real-world work assignment scenarios:​
- Role Match (40 points) - Highest-weighted category (specialty alignment directly impacts work quality and safety. A perfect match gets 40 points, while a partially qualified resource (alternate specialty) gets 20 points.)
- Skill Level (20 points) - Normalized to a 5-point scale (multiplied by 4), this rewards more experienced and capable resources.
- Experience (15 points) - Measured by total cases handled, capped at 150 cases (15 points max). This balances between fresh talent and veterans.
- Availability (15 points) - Resources available during the requested work time receive 15 points; those unavailable get 5 points to keep them in consideration for rescheduling scenarios. 
- Workload (10 points) - Current workload is inversely scored (10 - workload × 2), capped at 0.​

### In case of high Priority (110 points max)
For high-priority work (≥4), added dynamic scoring adjustments:​
    - +5 bonus to availability (up to 20 max)
    - +5 bonus to workload (up to 15 max)
    - Applied only if workload < 3 and the resource is available
This ensures urgent cases are assigned to immediately available resources with capacity, rather than those who might be slightly more skilled but overloaded.​

## Demonstration of 3 scenerios
Can check details of 'assignment_log' table in work_allocation.sql (phpmyadmin SQL dump) for the 3 scenerios.

### Scenerio 1: Urgent MRI_Brain Case (Priority 5)
LLM Reasoning: Dr. Sarah Chen (R005) is the best match for work W023 with a score of 94, demonstrating an exceptional fit based on her specialty as a Neurologist, high skill level, and extensive experience. Her high availability and perfect role match, alongside a reasonable current workload, further solidify this assignment, despite a moderate workload score.

### Scenario 2: Routine Ultrasound_Abdomen (Priority 2)
LLM Reasoning: Dr. John Smith (R001) is the best match for work W024 with a score of 92, driven by a perfect role match as a General Radiologist, high skill level, and extensive experience. His good availability and manageable current workload further solidify this optimal assignment.

### Scenario 3: Specialized X_Ray_Bone (Priority 3)
LLM Reasoning:  Dr. David Lee (R012) is the best match for work W025 with a score of 86, largely due to his perfect role match as a Musculoskeletal Specialist, high skill level, and extensive experience. Although his availability score is lower, his strong performance in other critical areas makes him the most suitable candidate for this specialized x-ray.

## Screenshots
These are the screenshots of phpmyadmin, docker containers working, the outputs from demonstrations.
<img width="1572" height="892" alt="Screenshot 2025-11-19 151552" src="https://github.com/user-attachments/assets/c42a6570-6a21-446f-9b81-926e77e57db6" />
<img width="1470" height="225" alt="Screenshot 2025-11-19 151625" src="https://github.com/user-attachments/assets/5789b2f5-4dbb-408f-a93d-a18edd1efdf5" />
<img width="1358" height="657" alt="Screenshot 2025-11-20 003038" src="https://github.com/user-attachments/assets/0cb017b8-6864-4cb0-a273-f6440e93778b" />
<img width="1355" height="690" alt="Screenshot 2025-11-20 003049" src="https://github.com/user-attachments/assets/b79480b1-ef2d-48b9-a10d-63efc5880a67" />
<img width="1354" height="713" alt="Screenshot 2025-11-20 003059" src="https://github.com/user-attachments/assets/f0e7bd86-8e9b-4fc3-9aa9-6745f092ddb9" />
<img width="1373" height="113" alt="Screenshot 2025-11-19 235546" src="https://github.com/user-attachments/assets/759ccfab-0b92-4e8f-8455-14f81a1c5bfd" />
<img width="1919" height="876" alt="Screenshot 2025-11-19 235519" src="https://github.com/user-attachments/assets/f1659e60-c983-4a9d-8335-20d25ea68e47" />
