# OpenTelemetry Schema Processors for Fluent Bit
The following repository contains Lua files for Fluent Bit that convert well-known log types into compatible OpenTelemetry Schemas. Leveraging the lua filter and the JSON simple schema provided by OpenSearch Fluent Bit attempts to change input log files into the well defined schema.

The table below provides an overview for Schemas that users can start to leverage

# Schemas
| Application | Status |
| ---- | ---- |
| nginx | complete |
| Apache | complete |
| AWS ELB | complete / testing needed |
| AWS VPC Flow Log | complete / testing needed |
| AWS S3 Access Logs | |
| AWS CloudTrail | complete / testing needed |
| AWS RDS | |
| Amazon ElastiCache | |
| Auditd | |
| Kubernetes System Logs | |
| MySQL | |
| AWS WAF | |
| AWS CloudFront | complete / testing needed |
| Kafka | | 
