# ansible-template
Ansible repository template

The UBI image build and bootstrap workflows resolve the latest stable
`actions/runner` release from GitHub on every workflow run. All architectures
in a run use the same resolved version, which is logged during versioning and
baked into the image. Release lookup or version validation failures stop the
build; there is no pinned fallback. Containers use the runner included in the
image, so obtaining a newer runner requires a new image build.

UBI image tags use `<runner-version>-<github.run_number>` on `main` and
`<runner-version>-DEV.<github.run_number>` on other refs, including pull requests.
For example, build 123 produces `2.337.0-123` on main or `2.337.0-DEV.123`
on a feature branch. Architecture tags keep the `x64-` and `arm64-` prefixes;
build and UAT tags add `.SNAPSHOT` until promotion. Only main updates the UBI
`latest` manifest. Reruns reuse the same workflow build number.

UBI builds explicitly pass `linux/amd64` or `linux/arm64` through the shared
Docker action's `platform` input.

Manual runs are available from the Actions tab for **Ubi Agent Build and Deploy**,
**Builder Image**, and **Ansible Agent Image**. Select the workflow, choose
**Run workflow**, and select the branch. The workflow must first be present on
the default branch for GitHub to expose its manual trigger.

Manual runs execute the full existing build, UAT, promotion, cleanup, and
deployment stages applicable to each agent. The standalone Ansible workflow
builds `deploy/` for x64 and ARM64 using the published UBI base image, publishes
`x64-ansible-` / `arm64-ansible-` architecture tags and an `ansible-` common tag,
and deploys runners with the `ansible` label. Main runs also update
`ansible-latest`. The existing bootstrap workflow remains available separately.
