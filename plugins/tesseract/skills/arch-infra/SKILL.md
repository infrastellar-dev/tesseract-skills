---
name: arch-infra
description: Scan infrastructure and deployment configuration in the codebase to add components to the Tesseract architecture diagram. Use to map CI/CD, containers, proxies and cloud services.
disable-model-invocation: true
allowed-tools: Glob, Grep, Read, Bash, Task, mcp__tesseract__list_types, mcp__tesseract__list_components, mcp__tesseract__get_graph, mcp__tesseract__get_user_context, mcp__tesseract__add_component, mcp__tesseract__update_component, mcp__tesseract__remove_component, mcp__tesseract__add_connection, mcp__tesseract__update_connection, mcp__tesseract__remove_connection, mcp__tesseract__look_at, mcp__tesseract__annotate, mcp__tesseract__update_project, mcp__tesseract__screenshot, mcp__tesseract__export_mermaid, mcp__tesseract__import_mermaid, mcp__tesseract__list_layers, mcp__tesseract__add_layer, mcp__tesseract__update_layer, mcp__tesseract__remove_layer, mcp__tesseract__reorder_layers, mcp__tesseract__highlight_path, mcp__tesseract__clear_highlights, mcp__tesseract__save_flow, mcp__tesseract__list_flows, mcp__tesseract__show_flow, mcp__tesseract__update_flow, mcp__tesseract__delete_flow, mcp__tesseract__prepare_download, mcp__tesseract__confirm_download, mcp__tesseract__prepare_upload, mcp__tesseract__auto_layout, mcp__tesseract__pin_all, mcp__tesseract__unpin_components
---

# Architecture — Infrastructure

You are an architecture analyst. Scan the codebase for infrastructure and
deployment configuration, then add relevant components to the Tesseract diagram.

## Workflow

1. **Read layout rules** — `Read` the file `${CLAUDE_PLUGIN_ROOT}/LAYOUT.md` and
   follow all placement and connection routing guidelines.
2. **Discover available types** — call `list_types`.
3. **Check existing graph** — call `get_graph` to avoid duplicates.
4. **Scan the codebase** for infra configuration using the patterns below.
5. **Present a summary** — list each infra component with name, type, tech.
   Wait for confirmation.
6. **Pin existing components** — call `pin_all` and save the returned IDs.
7. **Create components and connections** in Tesseract (no positions needed).
8. **Run auto layout** — call `auto_layout` to place new components.
9. **Unpin** — call `unpin_components` with the IDs from step 6.
10. **Verify layout** — take a `screenshot`, check for overlaps and crossing
   connections, fix with `update_component` or `update_connection` (curvature).
11. **Navigate** — `look_at` the main gateway or load balancer.

## What to scan

- `**/Dockerfile*` — container definitions
- `**/docker-compose*.yml` — multi-container orchestration
- `**/k8s/**`, `**/kubernetes/**`, `**/helm/**` — Kubernetes manifests
- `**/terraform/**`, `**/*.tf` — Terraform IaC
- `**/.github/workflows/**` — GitHub Actions CI/CD
- `**/.gitlab-ci.yml` — GitLab CI
- `**/Jenkinsfile` — Jenkins pipelines
- `**/nginx.conf`, `**/Caddyfile`, `**/traefik.*` — reverse proxies
- `**/cloudformation/**`, `**/cdk/**` — AWS CloudFormation/CDK
- `**/pulumi/**` — Pulumi IaC

## Component type mapping

| Code pattern | Tesseract type |
|---|---|
| Nginx / Traefik / HAProxy | Gateway/API Gateway |
| Load balancer | Gateway/Load Balancer |
| CDN (CloudFront, Cloudflare) | Gateway/CDN |
| CI/CD pipeline | Compute/CI/CD |
| Kubernetes cluster | Compute/Kubernetes |
| Docker container (standalone) | Compute/Container |
| Serverless function (Lambda, Cloud Functions) | Compute/Serverless |
| DNS / domain config | External/DNS |

## Rules

- Do NOT create duplicate components — check `get_graph` first.
- Focus on infrastructure components that are architecturally relevant.
- Skip individual CI steps — represent CI/CD as one component.
- Annotate components with key config details (replicas, resources, etc.).
- Always confirm with the user before creating components.
