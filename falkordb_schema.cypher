// =============================================================================
// GraphSentinel AI — FalkorDB Context Graph Schema & Seed Data
// Hackathon: Graph Hacks (WeMakeDevs & FalkorDB)
// Tracks: 01 (Connected Data), 02 (Memory & Coordination), 03 (Company Brain)
// =============================================================================

// 1. Clear existing graph (optional during initialization)
// MATCH (n) DETACH DELETE n;

// 2. Create Infrastructure & Microservices Topology
CREATE (gw:Gateway {id: 'api-gateway', name: 'API Gateway Ingress', type: 'ingress', tier: 'Tier-0', port: 443, status: 'HEALTHY'})
CREATE (auth:Service {id: 'auth-service', name: 'Authentication Service', type: 'microservice', tier: 'Tier-0', language: 'Go', status: 'HEALTHY'})
CREATE (order:Service {id: 'order-service', name: 'Order Processing Service', type: 'microservice', tier: 'Tier-1', language: 'Python', status: 'HEALTHY'})
CREATE (payment:Service {id: 'payment-service', name: 'Payment Transaction Engine', type: 'microservice', tier: 'Tier-0', language: 'Java', status: 'VULNERABLE'})
CREATE (notify:Service {id: 'notification-worker', name: 'Notification Dispatcher', type: 'worker', tier: 'Tier-2', language: 'Node.js', status: 'HEALTHY'})

// 3. Create Datastores & Third-Party APIs
CREATE (userdb:Database {id: 'user-db', name: 'PostgreSQL User DB', engine: 'PostgreSQL 16', storage: '500GB', status: 'HEALTHY'})
CREATE (orderdb:Database {id: 'order-db', name: 'PostgreSQL Order DB', engine: 'PostgreSQL 16', storage: '1.2TB', status: 'HEALTHY'})
CREATE (cache:Cache {id: 'redis-cache', name: 'Redis Cluster Cache', engine: 'Redis 7.2', memory: '64GB', status: 'HEALTHY'})
CREATE (stripe:ExternalAPI {id: 'stripe-api', name: 'Stripe Payment Gateway', vendor: 'Stripe Inc.', endpoint: 'api.stripe.com', status: 'HEALTHY'})

// 4. Create Security Vulnerabilities & CVE Nodes
CREATE (cve:Vulnerability {id: 'cve-2026-9921', name: 'CVE-2026-9921', severity: 'CRITICAL', cvss: 9.8, type: 'Remote Code Execution', package: 'fastjson-core'})

// 5. Create Organization & Engineering Ownership (Track 03 - Company Brain)
CREATE (secTeam:Team {name: 'Security Operations', lead: 'Marcus Vance', channel: '#sec-ops', onCall: 'sec-pager@corp.internal'})
CREATE (payTeam:Team {name: 'Payments Core Team', lead: 'Elena Rostova', channel: '#team-payments', onCall: 'pay-pager@corp.internal'})
CREATE (devMarcus:Engineer {name: 'Marcus Vance', role: 'Staff Security Engineer', email: 'marcus@corp.internal'})
CREATE (devElena:Engineer {name: 'Elena Rostova', role: 'Principal Backend Engineer', email: 'elena@corp.internal'})

// 6. Create Agent Persistent Memory Graph (Track 02 - Agent Memory & Coordination)
CREATE (incPrev:Incident {id: 'INC-2026-0921', title: 'Payment Gateway Cascading Latency Spike', date: '2026-09-21', resolution: 'Circuit breaker tripped on Order Service; fallback to cached orders'})
CREATE (runbook:Runbook {id: 'RB-ISOLATE-POD', title: 'Kubernetes Pod Traffic Shedding & Isolation', mcpTool: 'k8s_circuit_breaker', automated: true})

// 7. Establish Relationships Between Services, Databases, and Gateways
CREATE (gw)-[:ROUTES_TO {protocol: 'HTTPS', timeout_ms: 1500}]->(auth)
CREATE (gw)-[:ROUTES_TO {protocol: 'HTTPS', timeout_ms: 3000}]->(order)

CREATE (auth)-[:CACHES_IN {ttl_sec: 3600}]->(cache)
CREATE (auth)-[:QUERIES {pool_size: 20}]->(userdb)

CREATE (order)-[:CALLS {method: 'POST /v1/charge', retry_count: 2}]->(payment)
CREATE (order)-[:PERSISTS {acid: true}]->(orderdb)
CREATE (order)-[:PUBLISHES {queue: 'order-events'}]->(notify)

CREATE (payment)-[:INTEGRATES_WITH {webhook: true}]->(stripe)
CREATE (payment)-[:AFFECTED_BY {discovered: '2026-10-14'}]->(cve)

// 8. Connect Teams, Engineers, and Incidents (Provenance & Memory)
CREATE (payTeam)-[:OWNS]->(payment)
CREATE (payTeam)-[:OWNS]->(order)
CREATE (devElena)-[:LEADS]->(payTeam)
CREATE (devMarcus)-[:LEADS]->(secTeam)

CREATE (incPrev)-[:ROOT_CAUSE_WAS]->(payment)
CREATE (incPrev)-[:MITIGATED_BY]->(runbook)
CREATE (payment)-[:GOVERNED_BY]->(runbook);

// =============================================================================
// Sample Verification Cypher Queries:
//
// 1. Calculate Multi-Hop Blast Radius for Payment Service Outage:
// MATCH path = (dependent)-[:ROUTES_TO|CALLS*1..3]->(target {id: 'payment-service'})
// RETURN dependent.name AS ImpactedNode, length(path) AS Depth;
//
// 2. Tracing Ownership & On-Call for Vulnerable Systems:
// MATCH (v:Vulnerability {id: 'cve-2026-9921'})<-[:AFFECTED_BY]-(s:Service)<-[:OWNS]-(t:Team)
// RETURN s.name AS VulnerableService, t.name AS ResponsibleTeam, t.lead AS TeamLead, t.onCall AS Pager;
//
// 3. Episodic Agent Memory Query for Similar Incidents:
// MATCH (target {id: 'payment-service'})<-[:ROOT_CAUSE_WAS]-(prev:Incident)-[:MITIGATED_BY]->(rb:Runbook)
// RETURN prev.title, prev.resolution, rb.mcpTool;
// =============================================================================
