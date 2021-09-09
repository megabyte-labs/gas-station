## Pull Requests

All pull requests should be associated with issues. You can find the [issues board on GitLab]({{ repository.playbooks }}). The pull requests should be made to [the GitLab repository]({{ repository.group.ansible_roles }}/{{ role_name }}) instead of the [GitHub repository]({{ profile.github }}/ansible-{{ role_name }}). This is because we use GitLab as our primary repository and mirror the changes to GitHub for the community.

### How to Commit Code

Instead of using `git commit`, we prefer that you use `npm run commit`. You will understand why when you try it but basically it streamlines the commit process and helps us generate better `CHANGELOG.md` files.

### Pre-Commit Hook

Even if you decide not to use `npm run commit`, you will see that `git commit` behaves differently since the pre-commit hook is installed when you run `npm i`. This pre-commit hook is there to test your code before committing. If you need to bypass the pre-commit hook, then you will have to add the `--no-verify` tag at the end of your `git commit` command (e.g. `git commit -m "Commit" --no-verify`).
