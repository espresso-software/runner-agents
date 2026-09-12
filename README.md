# ansible-template
Ansible repository template

The UBI image build and bootstrap workflows resolve the latest stable
`actions/runner` release from GitHub on every workflow run. All architectures
in a run use the same resolved version, which is logged during versioning and
baked into the image. Release lookup or version validation failures stop the
build; there is no pinned fallback. Containers use the runner included in the
image, so obtaining a newer runner requires a new image build.
