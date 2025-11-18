# Intelligent Work Allocation System
**Clovertex GenAI Internship Assignment**

An AI-powered radiology work allocation system using multi-agent architecture with LangGraph, demonstrating intelligent resource assignment based on expertise, availability, and workload optimization.

---

## 📋 Table of Contents
- [Overview](#overview)
- [Features](#features)
- [Technology Stack](#technology-stack)
- [Installation](#installation)
- [Usage](#usage)
- [Architecture](#architecture)
- [Design Decisions](#design-decisions)
- [Scoring Logic](#scoring-logic)
- [Project Structure](#project-structure)
- [Conclusion](#conclusion)

---

## 🎯 Overview

This system intelligently assigns radiology work requests to available radiologists using a 5-agent architecture orchestrated with LangGraph. Each agent has a specific responsibility in the assignment workflow, from receiving requests to generating AI-powered explanations for assignments.

### Key Capabilities
- **Multi-agent orchestration** using LangGraph StateGraph
- **Transparent 100-point scoring system** for resource selection
- **LLM-powered explanations** via Google Gemini API
- **Database-driven** workflow with SQLite
- **Production-ready** error handling and transaction management

---

## ✨ Features

### Core Functionality
- ✅ 5-agent sequential workflow
- ✅ Intelligent specialty matching (exact + alternate)
- ✅ Weighted scoring algorithm (skill, experience, availability, workload)
- ✅ Priority-based urgent case handling
- ✅ Real-time availability checking
- ✅ Workload balancing across resources
- ✅ AI-generated assignment explanations

### Technical Features
- ✅ LangGraph state management
- ✅ SQLite with foreign key constraints
- ✅ Transaction safety (BEGIN/COMMIT/ROLLBACK)
- ✅ Comprehensive error handling
- ✅ Type hints throughout codebase
- ✅ Modular, extensible design

---

## 🛠️ Technology Stack

### Framework & Orchestration
- **LangGraph** - Agent workflow orchestration
- **Python 3.8+** - Core language

### LLM Integration
- **Google Gemini API (gemini-pro)** - Assignment explanations
- Alternative: Amazon Bedrock, Ollama, HuggingFace Inference API

### Database
- **SQLite** - Relational database
- Alternative: PostgreSQL, MySQL

### Core Libraries
```
langgraph==0.2.45
google-generativeai==0.3.2
pandas==2.1.4
python-dotenv==1.0.0
```

---

## 📦 Installation

### Prerequisites
- Python 3.8 or higher
- pip package manager
- Google Gemini API key

### Step 1: Clone Repository
```bash
git clone <repository-url>
cd intelligent-work-allocation
```

### Step 2: Create Virtual Environment
```bash
# Windows
python -m venv .venv
.venv\Scripts\activate

# Mac/Linux
python3 -m venv .venv
source .venv/bin/activate
```

### Step 3: Install Dependencies
```bash
pip install -r requirements.txt
```

### Step 4: Configure API Key
Create a `.env` file in the project root:
```env
GEMINI_API_KEY=your_api_key_here
```

Get your API key from: https://makersuite.google.com/app/apikey

### Step 5: Setup Database
The database is automatically created when you run the notebook. CSV data files should be in the `data/` folder:
```
data/
├── resources.csv
├── resource_calendar.csv
├── work_requests.csv
└── specialty_mapping.csv
```

---

## 🚀 Usage

### Running the Notebook
1. Start Jupyter:
```bash
jupyter notebook
```

2. Open `demo.ipynb`

3. Run cells in order:
   - Cell 1-2: Import libraries and define state
   - Cell 3: Database Manager class
   - Cell 4: Resource Scorer class
   - Cell 5: Agent node functions
   - Cell 6: LangGraph workflow
   - Cell 7: Initialize database
   - Cells 8-10: Run 3 test scenarios

### Test Scenarios Included
1. **Urgent Neurological Case** (Priority 5, MRI_Brain)
2. **Routine Chest X-Ray** (Priority 2, X_Ray_Chest)
3. **Specialized Mammography** (Priority 3, Mammography - alternate specialty)

### Expected Output
Each scenario shows:
- Agent-by-agent workflow execution
- Candidate scoring details
- Best resource selection
- Database updates confirmation
- AI-generated explanation

---

## 🏗️ Architecture

### System Components
```
┌─────────────────┐
│  User Request   │
└────────┬────────┘
         │
         ▼
┌─────────────────────────────────────┐
│       LangGraph Orchestrator        │
│  ┌───────────────────────────────┐  │
│  │  Agent 1: AddWorkAgent        │  │
│  └───────────┬───────────────────┘  │
│              ▼                       │
│  ┌───────────────────────────────┐  │
│  │  Agent 2: WorkAnalyzerAgent   │  │
│  └───────────┬───────────────────┘  │
│              ▼                       │
│  ┌───────────────────────────────┐  │
│  │  Agent 3: ResourceFinderAgent │  │
│  └───────────┬───────────────────┘  │
│              ▼                       │
│  ┌───────────────────────────────┐  │
│  │  Agent 4: AvailabilityChecker │  │
│  └───────────┬───────────────────┘  │
│              ▼                       │
│  ┌───────────────────────────────┐  │
│  │  Agent 5: AssignmentAgent     │  │
│  └───────────┬───────────────────┘  │
└──────────────┼──────────────────────┘
               ▼
      ┌─────────────────┐
      │  SQLite Database │
      └─────────────────┘
               ▼
      ┌─────────────────┐
      │   Gemini API    │
      └─────────────────┘
```

### Agent Responsibilities

**Agent 1: AddWorkAgent**
- Validates input parameters
- Inserts work request into database
- Generates unique work_id
- Returns: work_id

**Agent 2: WorkAnalyzerAgent**
- Retrieves work request details
- Determines required specialty from mapping
- Identifies alternate specialty (if available)
- Returns: required_specialty, alternate_specialty

**Agent 3: ResourceFinderAgent**
- Queries resources by specialty
- Finds primary candidates (exact match)
- Finds alternate candidates (if needed)
- Returns: primary_candidates, alternate_candidates

**Agent 4: AvailabilityCheckerAgent**
- Checks availability for each candidate
- Calculates 100-point score
- Ranks candidates by score
- Returns: best_candidate, all_candidates

**Agent 5: AssignmentAgent**
- Updates database (work_requests, resources, resource_calendar)
- Generates AI explanation via Gemini API
- Returns: final_result with explanation

---

## 📊 Scoring Logic

### 100-Point Weighted System

#### Component Breakdown

| Component | Weight | Max Points | Calculation |
|-----------|--------|------------|-------------|
| **Skill Level** | 25% | 25 | `(skill_level / 5) × 25` |
| **Experience** | 20% | 20 | `min(total_cases / 20, 20)` |
| **Availability** | 30% | 30 | `(hours_available / 8) × 30` |
| **Workload** | 15% | 15 | `max(0, 15 - workload × 1.5)` |
| **Priority Bonus** | 10% | 10 | Urgent cases get full 10 pts |
| **TOTAL** | 100% | 100 | Sum of above |

#### Specialty Multiplier
- **Exact match:** 1.0× (no penalty)
- **Alternate match:** 0.8× (20% penalty)

#### Priority Bonus Logic
```python
if priority >= 4 and workload <= 2:
    bonus = 10  # Full bonus for urgent + available
else:
    bonus = (priority / 5) × 10  # Scaled bonus
```

### Example Calculation

**Scenario:** Neurologist with skill=5, 345 cases, 8 hours available, 2 workload, priority=5

```
Skill:         (5/5) × 25 = 25.00
Experience:    min(345/20, 20) = 20.00
Availability:  (8/8) × 30 = 30.00
Workload:      15 - (2 × 1.5) = 12.00
Priority:      10.00 (urgent + low workload)
─────────────────────────────────────
Subtotal:      97.00
Multiplier:    1.0 (exact match)
─────────────────────────────────────
TOTAL SCORE:   97.00 / 100
```

### Why These Weights?

**Availability (30%)** - Highest weight because unavailable = can't assign

**Skill Level (25%)** - Critical for quality, especially complex cases

**Experience (20%)** - Proven track record matters

**Workload (15%)** - Balance load but not primary concern

**Priority Bonus (10%)** - Tiebreaker for urgent cases

---

## 📁 Project Structure

```
intelligent-work-allocation/
├── demo.ipynb                 # Main Jupyter notebook
├── README.md                  # This file
├── requirements.txt           # Python dependencies
├── .env                       # API keys (not in git)
├── .gitignore                 # Git ignore file
├── radiology.db               # SQLite database (generated)
│
├── data/                      # CSV data files
│   ├── resources.csv
│   ├── resource_calendar.csv
│   ├── work_requests.csv
│   └── specialty_mapping.csv
│
└── diagrams/                  # Architecture diagrams
    ├── ArchitectureDiagram.png       # System architecture
    └── SequenceDiagram.jpg           # Sequence diagram
 
```

---

## Conclusion
This project is for educational purposes as part of the Clovertex GenAI Internship assignment.

---