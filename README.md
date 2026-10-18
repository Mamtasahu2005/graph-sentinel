# ⚡ GraphSentinel AI
> **Context-Aware Autonomous Incident & Security Investigator for AI Agents**  
> *Built for [Graph Hacks 2026](https://www.wemakedevs.org/hackathons/falkordb) by WeMakeDevs & FalkorDB*

[![FalkorDB](https://img.shields.io/badge/FalkorDB-Graph%20Engine-purple.svg)](https://www.falkordb.com/)
[![Track 01](https://img.shields.io/badge/Track%2001-Connected%20Data-blue.svg)](https://www.wemakedevs.org/hackathons/falkordb#tracks)
[![Track 02](https://img.shields.io/badge/Track%2002-Agent%20Memory-indigo.svg)](https://www.wemakedevs.org/hackathons/falkordb#tracks)
[![Track 03](https://img.shields.io/badge/Track%2003-Company%20Brain-emerald.svg)](https://www.wemakedevs.org/hackathons/falkordb#tracks)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

---

## 🎯 The Core Problem & The FalkorDB Shift

### ❌ The Problem: Disconnected, Forgetful Agents
Traditional AI agents rely on flat vector search (Vector RAG). When critical infrastructure fails or a CVE is flagged:
1. **Blind to Multi-Hop Cascades:** An LLM cannot determine if a failure in `payment-service` will take down `order-service` and trip the `api-gateway`.
2. **Session Amnesia:** Agents lose context across sessions and cannot recall how a similar outage was resolved last week.
3. **Unexplainable Hallucinations:** Traditional agents make arbitrary tool calls with no mathematical provenance or topological certainty.

### ✅ The Shift: FalkorDB as the Context & Memory Layer
**GraphSentinel AI** stores microservices, datastores, CVE security vulnerabilities, engineering team ownership, and past runbooks in **FalkorDB**.
- **< 1.2ms Graph Traversals:** The agent traverses multi-hop dependency paths inside its real-time reasoning loop.
- **Cross-Session Episodic Memory:** Resolving an incident creates new graph edges (`(:Incident)-[:RESOLVED_WITH]->(:Runbook)`) persisted in FalkorDB.
- **Explainable Model Context Protocol (MCP) Actions:** Every autonomous action (e.g., traffic shedding, pod isolation) is grounded in verified graph topology.

---

## 🏆 Hackathon Tracks Alignment

| Track | Alignment in GraphSentinel AI | Winning Criteria |
| :--- | :--- | :--- |
| **Track 01: Agents That Act on Connected Data** | Autonomous blast radius calculation via multi-hop OpenCypher traversals. Graph queries and algorithms act as primary agent tools via MCP. | **iPhone 18 Pro** |
| **Track 02: Agent Memory & Coordination** | Persistent **episodic** (incident history), **semantic** (org architecture), and **procedural** (runbook policies) graph memory with multi-tenant graph isolation. | **PS5 with GTA VI** |
| **Track 03: Company Brain** | Unifies code dependencies, CVE vulnerabilities, and human ownership (`Team -> Tech Lead -> On-Call Pager`) into one queryable graph. | **M6 Mac Mini** |

---

## 🏗️ Architecture

```
                      +-----------------------------+
                      |   Live Cloud / Alert Feed   |
                      | (Prometheus, Datadog, CVEs) |
                      +--------------+--------------+
                                     |
                                     v
                 +---------------------------------------+
                 |    GraphSentinel AI Agent Engine      |
                 | (Multi-Hop Reasoner + MCP Dispatcher) |
                 +-------------------+-------------------+
                                     |
                OpenCypher Queries   |   Episodic Memory Recalls
                & Graph Algorithms   |   & Cross-Session State
                                     v
                       +---------------------------+
                       |   FalkorDB Graph Engine   |
                       | (In-Memory Cypher Graph)  |
                       +-------------+-------------+
                                     |
         +---------------------------+---------------------------+
         |                                                       |
         v                                                       v
+-------------------------------+               +-------------------------------+
|     Infrastructure Graph      |               |     Agent Memory Graph        |
|  - API Gateways & Ingress     |               |  - Past Incident Sessions     |
|  - Microservices (Go/Java)    |               |  - Verified MCP Runbooks      |
|  - Relational & Redis DBs     |               |  - Engineering Ownership      |
|  - CVE Security Nodes         |               |  - Multi-Tenant Partitions    |
+-------------------------------+               +-------------------------------+
```

---

## 🚀 Quickstart (Run in 60 Seconds)

### Option 1: Docker Compose (Recommended)
Launch both **FalkorDB** and **GraphSentinel AI** with a single command:
```bash
docker compose up -d
```
- Web Application & Studio: **[http://localhost:8080](http://localhost:8080)**
- FalkorDB Browser: **[http://localhost:3000](http://localhost:3000)**

### Option 2: Standalone Local Run
1. Start FalkorDB via Docker:
```bash
docker run -p 6379:6379 -p 3000:3000 -it --rm falkordb/falkordb:latest
```

2. Seed the graph schema:
```bash
# Seed via falkordb-cli or python client
cat falkordb_schema.cypher | docker exec -i graph-sentinel-falkordb falkordb-cli
```

3. Launch GraphSentinel backend:
```bash
python backend/server.py
```
Open **[http://localhost:8080](http://localhost:8080)** in your browser!

---

## 🔍 Core OpenCypher Queries Used by the Agent

### 1. Multi-Hop Blast Radius Calculation
```cypher
MATCH path = (dependent)-[:ROUTES_TO|CALLS*1..3]->(target {id: 'payment-service'})
RETURN dependent.name AS ImpactedNode, length(path) AS Depth;
```

### 2. Cross-Session Episodic Memory Lookup
```cypher
MATCH (target {id: 'payment-service'})<-[:ROOT_CAUSE_WAS]-(prev:Incident)-[:MITIGATED_BY]->(rb:Runbook)
RETURN prev.title, prev.resolution, rb.mcpTool;
```

### 3. Ownership & On-Call Provenance
```cypher
MATCH (v:Vulnerability {id: 'cve-2026-9921'})<-[:AFFECTED_BY]-(s:Service)<-[:OWNS]-(t:Team)
RETURN s.name AS VulnerableService, t.name AS Team, t.lead AS Lead, t.onCall AS Pager;
```

---

## 🎥 Video Demo Walkthrough Script

1. **The Hook (0:00 - 0:30):** Introduce why flat vector RAG is blind to microservice dependency chains and why AI agents need FalkorDB graph context.
2. **Interactive Topology (0:30 - 1:15):** Show the interactive canvas graph rendering real services, PostgreSQL datastores, and Redis caches.
3. **Live Incident Simulation (1:15 - 2:00):** Click *Scenario A (Payment Gateway Cascade)*. Demonstrate the agent traversing 2-hop blast radii in 1.1ms.
4. **Agent Memory in Action (2:00 - 2:30):** Show the agent recalling past incident `#INC-2026-0921` from FalkorDB episodic memory and automatically selecting the correct Kubernetes circuit breaker runbook via MCP.
5. **Conclusion & Tracks (2:30 - 3:00):** Recap compliance across Track 01, Track 02, and Track 03.

---

## 📜 License
MIT License &copy; 2026 GraphSentinel Team. Built for WeMakeDevs Graph Hacks Hackathon.
