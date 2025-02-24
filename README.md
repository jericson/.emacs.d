# .emacs.d

To use this on a new computer, make sure you have git installed and
clone this prepository:

```
git clone https://github.com/jericson/.emacs.d.git
```

This will set up Emacs the way I like it.

## Installing when you already have .emacs.d

Git won't clone a repository over an existing directory, so this won't
work if you've arleady run Emacs. The easiest solution is:

1. Quit Emacs.
2. Move/rename `.emacs.d` to something else.
3. Clone this repository.
4. Copy the files from the renamed `.emacs.d` to the fresh directory.
5. Test by starting up Emacs again and doing Emacs stuff.
6. (Optional) Commit any changes to the initialization file.
7. (Recommended) Remove the old copy of `.emacs.d`.

## Reuse

Please fork this repository! 

I will gladly accept PRs that work with my workflow. I will
reluctantly change my workflow if there's a compelling reason to do
so. ;-)
