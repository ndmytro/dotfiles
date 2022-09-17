my dotfiles
===========

quick start
-----------

Requires a single prerequisite - [stow] (to avoid using `cp` or `ln`)

* 1:

  ```bash
  $ git clone https://github.com/ndmytro/dotfiles && cd dotfiles
  ```

* 2:

  ```bash
  $ stow -t ~ {app}
  ```

  * `{app}` - app name, corresponds to the directories in the root of the repository


[stow]: https://www.gnu.org/software/stow/
