# How this website was created

1. Built website with [blogdown](https://bookdown.org/yihui/blogdown/), which is a R-based wrapper/magic-maker for Hugo. Using [Xmin](https://github.com/yihui/hugo-xmin) theme.
  - Very light customization applied. A bit of CSS styling.
2. Served website with [Netlify](https://www.netlify.com/).
  - Added `_redirect` file per Netlify instructions.
3. Updated DNS settings in Namecheap as follows (this took a bit of fiddling):
  - type: A; host: @; value: 104.198.14.52
  - type: CNAME; host: www; value: festive-joliot-dc4714.netlify.com.
4. Netlify basically set up https on its own, apparently issued (for free) using Let's Encrypt
