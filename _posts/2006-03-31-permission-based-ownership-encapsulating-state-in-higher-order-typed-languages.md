--- 
wordpress_id: 1664
layout: post
title: "Permission-based ownership: encapsulating state in higher-order typed languages"
wordpress_url: http://passingcuriosity.com/2006/permission-based-ownership-encapsulating-state-in-higher-order-typed-languages/
---
<a class="title" href="http://www.cs.cmu.edu/~aldrich/papers/pldi05.pdf"> Permission-based ownership: encapsulating state in higher-order typed languages </a> by Neel Krishnaswami and Jonathan Aldrich. In PLDI'05.<br /><br />I'm still puzzling through the examples, but it looks pretty cool. The essential idea is to use the type system (an extension of <acronym>System F</acronym> with references and ownership called <acronym>System F<sub><i>own</i></sub></acronym>) to ensure that the internal details of modules cannot be messed with. <br /><br />They give an illustrative example involving customers in one domain, banking machinery in a second and account details in a third. The customers are allowed to call the banking machinery, and the banking machinery can access the account details, and all other access is invalid. The goal of <acronym>System F<sub><i>own</i></sub></acronym> is to prove these sorts of properties.<br /><br /><a href="http://portal.acm.org/citation.cfm?id=1065023">ACM</a> | <a href="http://scholar.google.com/scholar?hl=en&lr=&safe=off&cluster=17777635342074588239">Google</a> | <a href="http://del.icio.us/url/7da65101851fdc40beda72a731be4341">Del.icio.us</a> | <a href="http://www.citeulike.org/article/471760">CiteULike</a>