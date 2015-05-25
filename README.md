#.emacs.d

##Table of Contents
- [Preface](https://github.com/manuel-uberti/.emacs.d#preface)
- [Overview](https://github.com/manuel-uberti/.emacs.d#overview)
- [Setup](https://github.com/manuel-uberti/.emacs.d#setup)
- [Updates](https://github.com/manuel-uberti/.emacs.d#updates)
- [Acknowledgements](https://github.com/manuel-uberti/.emacs.d#acknowledgements)

##Preface
This is the Emacs configuration I use everyday.

It requires **Emacs trunk** to work. I regularly update my sources from here:
```console
git://git.savannah.gnu.org/emacs.git
```

I use Emacs on **LinuxBBQ**. The ```esetup``` script helps to create the right
environment *before* starting Emacs with this configuration for the first
time. The script only works with **Debian-based** systems.

I mainly use Emacs for **LaTeX**, **Elisp** and **Clojure**, so my setup is
planned accordingly.

This configuration comes with more than **120 packages** carefully set up for my
daily usage. Check the ```.emacs.d/lisp``` directory for the gory details.

##Overview
- Theme: [Solarized Light](https://github.com/bbatsov/solarized-emacs)
- Font: [Source Code Pro](https://github.com/adobe-fonts/source-code-pro), [dynamic-fonts](https://github.com/rolandwalker/dynamic-fonts)
- Package management: [use-package](https://github.com/jwiegley/use-package), [Paradox](https://github.com/Bruce-Connor/paradox)
- Mode-line: [smart-mode-line](https://github.com/Bruce-Connor/smart-mode-line), [anzu](https://github.com/syohex/emacs-anzu)
- Buffers selection and completion: [Helm](https://github.com/emacs-helm/helm), [ibuffer-vc](https://github.com/purcell/ibuffer-vc)
- Navigation: [Avy](https://github.com/abo-abo/avy),
[ace-window](https://github.com/abo-abo/ace-window),
[ace-link](https://github.com/abo-abo/ace-link)
- File and directories: [ztree](https://github.com/fourier/ztree)
- Editing: [Iedit](https://github.com/victorhge/iedit),
  [transpose-mark](https://github.com/AtticHacker/transpose-mark),
  [multiple-cursors](https://github.com/magnars/multiple-cursors.el)
- Undo: [Undo Tree](http://www.dr-qubit.org/emacs.php#undo-tree)
- Killing: [easy-kill](https://github.com/leoliu/easy-kill), [helm-show-kill-ring](https://tuhdo.github.io/helm-intro.html#sec-6)
- Coding: [Smartparens](https://github.com/Fuco1/smartparens), [aggressive-indent-mode](https://github.com/Malabarba/aggressive-indent-mode),
[macrostep](https://github.com/joddie/macrostep)
- Filling: [aggressive-fill-paragraph](https://github.com/davidshepherd7/aggressive-fill-paragraph-mode),
  [visual-fill-column](https://github.com/joostkremers/visual-fill-column)
- Search: [helm-ag](https://github.com/syohex/emacs-helm-ag),
[helm-swoop](https://github.com/ShingoFukuyama/helm-swoop)
- Highlights: [rainbow-delimiters](https://github.com/jlr/rainbow-delimiters),
[highlight-symbol](https://github.com/nschum/highlight-symbol.el),
[highlight-numbers](https://github.com/Fanael/highlight-numbers)
- Org-mode: [org-magit](https://github.com/magit/org-magit), [toc-org](https://github.com/snosov1/toc-org), [org2blog](https://github.com/punchagan/org2blog)
- LaTeX: [AUCTeX](http://www.gnu.org/software/auctex/index.html), [helm-bibtex](https://github.com/tmalsburg/helm-bibtex)
- Clojure: [CIDER](https://github.com/clojure-emacs/cider), [flycheck-clojure](https://github.com/clojure-emacs/squiggly-clojure)
- Web: [SX](https://github.com/vermiculus/sx.el),
  [Elfeed](https://github.com/skeeto/elfeed)
- PDF: [PDF Tools](https://github.com/politza/pdf-tools), [interleave](https://github.com/rudolfochrist/interleave)
- Auto-completion: [company-mode](https://github.com/company-mode/company-mode), [company-statistics](https://github.com/company-mode/company-statistics), [helm-company](https://github.com/yasuyk/helm-company)
- Syntax checking: [Flycheck](https://github.com/flycheck/flycheck),
[helm-flycheck](https://github.com/yasuyk/helm-flycheck)
- Language tools: [define-word](https://github.com/abo-abo/define-word), [voca-builder](https://github.com/yitang/voca-builder), [Synosaurus](https://github.com/rootzlevel/synosaurus), [langtool](https://github.com/mhayashi1120/Emacs-langtool)
- Version control: [Magit](https://github.com/magit/magit),
[magit-gh-pulls](https://github.com/sigma/magit-gh-pulls),
[diff-hl](https://github.com/dgutov/diff-hl)
- Project management: [Projectile](https://github.com/bbatsov/projectile)
- Slides: [Org-HTML-Slideshow](https://github.com/relevance/org-html-slideshow)
- Document conversion: [pandoc-mode](https://github.com/joostkremers/pandoc-mode)
- Utilities: [The Bug Hunter](https://github.com/Malabarba/elisp-bug-hunter),
  [ESUP](https://github.com/jschaf/esup),
  [camcorder](https://github.com/Malabarba/camcorder.el)

##Setup
On your **Debian-based** machine:

- clone Emacs trunk:
```console
$ git clone git://git.savannah.gnu.org/emacs.git
```
- build Emacs trunk:
```console
$ cd emacs
$ sudo apt-get build-dep emacs24
$ ./configure
$ make
$ sudo make install
$ make clean
```
- clone this repo to your home directory:
```console
$ cd
$ git clone https://github.com/manuel-uberti/.emacs.d
```
- run ```esetup```:
```console
$ cd .emacs.d
$ chmod +x esetup
$ ./esetup
```
- run Emacs

##Updates
This configuration tracks latest Emacs developments. If you intend to use it, I highly recommend you update and re-build your sources once a week.

That is why if your build is more than seven days old, a warning will show up in the minibuffer reminding you to update the sources.

With the help of some tools such as [Magit](https://github.com/magit/magit), [Paradox](https://github.com/Bruce-Connor/paradox) and your preferred shell, maintenance is not that hard.

##Acknowledgements
This configuration would not have been possible without the work of and the
inspiration from these people:
- [Mickey Petersen](https://github.com/mickeynp)
- [Sebastian Wiesner](https://github.com/lunaryorn)
- [Artur Malabarba](https://github.com/Bruce-Connor)
- [Sacha Chua](https://github.com/sachac)
- [John Wiegley](https://github.com/jwiegley)
- [Bozhidar Batsov](https://github.com/bbatsov)
- [Magnar Sveen](https://github.com/magnars)
- [Steve Purcell](https://github.com/purcell)
- [Oleh Krehel](https://github.com/abo-abo)
- [Joe Brock](https://github.com/DebianJoe)
- [Wilfred Hughes](https://github.com/Wilfred)
