# DOKS development deployment
Desired state belongs in colors.yml. Never commit credentials, state or kubeconfig.
Run ./green build and ./green create --dry-run before live changes. Deletion is
protected; lift only for explicitly authorized cleanup. Never edit .colors output.
