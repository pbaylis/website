# How this website was created

1. Built website with [blogdown](https://bookdown.org/yihui/blogdown/), which is a R-based wrapper/magic-maker for Hugo. Using [Xmin](https://github.com/yihui/hugo-xmin) theme.
  - Very light customization applied. A bit of CSS styling.
2. Served website with [Netlify](https://www.netlify.com/).
  - Added `_redirects` file per Netlify [instructions](https://www.netlify.com/docs/redirects/).
3. Updated DNS settings in Namecheap as follows (this took a bit of fiddling):
  - type: `A`; host: @; value: 104.198.14.52
  - type: `CNAME`; host: www; value: festive-joliot-dc4714.netlify.com.
  - Removed other `A` entries and URL redirects (except for one other `CNAME` entry that I use for a subdomain).
4. Netlify basically set up https on its own (I think I clicked one button), which included an SSL certificate issued (for free) using Let's Encrypt. It took about a day before it started working, presumably due to some DNS propogation delay. This is handy because sites without encryption are increasingly viewed with suspicion by browsers: for example, as of Chrome 68, non-https sites are [marked as "Not Secure"](https://security.googleblog.com/2018/02/a-secure-web-is-here-to-stay.html).
