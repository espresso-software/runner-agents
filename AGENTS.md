# Repository Guidelines

## Project Structure & Module Organization

This repository builds self-hosted GitHub Actions runners and deploys them to Kubernetes using Ansible.

- `ubi-agent/`: base runner Dockerfile and startup, probe, and validation scripts.
- `builder/` and `deploy/`: Docker-enabled builder and Ansible runner images.
- `roles/`: Docker installation, runner deployment, and cleanup; Kubernetes manifests use `templates/*.yml.j2`.
- Root `*.yml`: Ansible entry-point playbooks.
- `inventory/`, `group_vars/`, and `host_vars/`: shared Git submodules; update their references deliberately.
- `.github/workflows/` and `.github/actions/`: image builds, version resolution, UAT, promotion, and deployment.

## Build, Test, and Development Commands

Run commands from the repository root:

- `git submodule update --init --recursive`: initialize shared inventory and configuration; repository access is required.
- `for script in ubi-agent/files/*.sh; do bash -n "$script" || exit; done`: check every shell script without executing runner registration.
- `ansible-playbook -i inventory/hosts.yml deploy.yml --syntax-check`: validate playbook syntax with Ansible, required collections, and applicable vault credentials available.
- `docker build -t runner-ansible:local deploy/`: build the Ansible image and execute its embedded dependency checks.

Base-image builds require an architecture-matched runner archive at `ubi-agent/files/actions-runner.tar.gz`; follow `.github/actions/ubi-agent-build/action.yml`. See [README.md](README.md) for image versioning and workflow operation.

## Coding Style & Naming Conventions

Use two-space YAML indentation, descriptive Ansible task names, and snake_case variables. Preserve surrounding shell and Dockerfile style. Keep Kubernetes templates in Jinja2 files and follow existing architecture/tag conventions. No repository-wide formatter or linter configuration is present.

## Testing Guidelines

There is no dedicated unit-test suite, test naming convention, or coverage threshold. Validate changed scripts and playbooks, build affected images, and use authorized workflow UAT for integration checks. Check both x64 and ARM64 when changing shared image behavior.

## Commit & Pull Request Guidelines

Use concise imperative commit subjects, such as `Use validated bootstrap token for runner registration`. PRs should explain behavior, scope, related issues, validation, and deployment effects.

This guide supplements the applicable personal espresso-software development guidance; consult that guidance for testing exceptions, commit-and-push approval, AI attribution, and deployment authorization.
