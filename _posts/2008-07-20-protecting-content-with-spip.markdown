--- 
wordpress_id: 125
layout: post
title: Protecting Content with SPIP
wordpress_url: http://passingcuriosity.com/?p=42
---
SPIP is a great CMS with lots of powerful features, but it does embed quite a lot of policy within its workings. One aspect of this is the difficulty of restricting access to content to authenticated users. Doing so is not particularly difficult, but doesn't appear to be documented in any great detail anywhere, so I'll describe the approach I used for one client's site.

<!--more-->

Before we get down to the details, I'll describe the use-case. The site this formed part of was for a small professional organisation. They wanted a way to post resources and a small forum both accessible only to their members. For various reasons, the site was to be implemented with SPIP, without any of the several forum plugins, and we very much wanted to keep the members from needing to access the SPIP back-end.

The first order of business was giving users accounts without allowing them to access the back-end. Thankfully SPIP has a number of different levels of user: administrators, editors, and visitors. Administrators can do anything, editors can create and modify content, and visitors can (depending on the configuration) participate in forums and petitions and suggest content. The visitor status is disabled by default, but can be enabled under "Site Configuration -> Interactivity" in the back-end. Somewhat confusingly, you cannot create a *visitor* account unless one already exists, but this didn't much matter as I used a script to create the hundred plus accounts anyway.

Once you're users have accounts, you need them to be able to login. There are two ways to do this: use the normal SPIP login page with a destination, or embed the login form in a template. The former  involves getting the user to `http://example.com/spip.php?page=login&url=`**`URL`** where the latter requires that you use `#LOGIN_PUBIC` to embed the login form in your page. In my case the designers included the a user-menu/login-form box on every page, so I had the decision made for me.

Telling when the user is or, more importantly, is not authenticated is a little trickier: you can either break out into PHP and check `$auteur_session` as described at the bottom of the [SPIP Forms](http://www.spip.net/en_article2474.html) documentation, or use the apparently undocumented `#SESSION` tag. I chose to use the former, but the latter is probably a better choice if you can be bothered figuring out how to use it (see the comments in `ecrire/public/balises.php`).

Tying this all together then: to protect the content displayed using a template you should use a piece code like the following.

    // If the user is authenticated...
    <?php if ($auteur_session): ?>
        // ...display the content
        [(#TEXTE|paragrapher)]
    <?php else: ?>
        // ...otherwise display the login form
        <p>This content is protected...</p>
        [(#LOGIN_PUBLIC)]
    <?php endif; ?>

Something that you should be aware of when doing this sort of thing the current version's (the 1.9 series) login form is, in my opinion, seriously broken by it's two-stage process, JavaScript of dubious utility and the fact that it leaks information like a sieve. Thankfully the development version that will become version 2.0 resolves many of these issues and you'd be well advised to wait for it, or use the redirection method (which I'll describe in a future post).
