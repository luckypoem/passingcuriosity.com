---
layout     : post
title      : Building document management systems in Drupal
categories : [ddu2011]
tags       : [drupal]
location   : Brisbane, Queensland
excerpt    : |
  Building a document management system in Drupal for the University of
  Queensland.
---

Academic group building the corporate application management platform in
Drupal instead of ITS doing it themselves.

Goal
----

University needs to maintain a collection of documents approved by the
University Senate. Things like HR, statutes, legislation, etc.

Replacing the current system of manually producing and approving documents,
passing them onto the web team who manually convert them into HTML and add
them to a static web site. Replace with an automated, managed workflow;
improve navigation; separate policies, procedures, guidelines and forms.

Outcome
=======

Drupal 6, ~30 contrib modules, almost no bespoke code.

Node types
----------

Policies, procedures, guidelines are content that live in the Drupal system
with their content and metadata.

Forms may have attachments (PDF, XLS, etc.) or a link to an external
application. Also includes metadata.

Used CCK, Field groups, conditional fields.

The metadata are treated as a fieldgroup for UI reasons:

- Document, notes (Text)
- Topic (Node reference)
- Approval date, review date, date superseded (Date)
- Approval authority, evaluation timeframe, audience, keywords (Content
  taxonomy fields)
- Links (Link)

Module called Taxonomy Role Delegation (or similar) that allows users to edit
taxonomies without admin permissions.

Body is a CCK field group.

Document types use CCK fields for body (why?). Forms use CCK Conditional
Fields to vary their form based on the form type (either a link or a file
field).

Workflow field for storing data about the workflow of the document: user
references to authors, reviewers; workflow state, evaluation details, approval
text (the email or minutes extract approving it).

CK Editor. Give users a bunch of Word templates with only the styles we want,
modify the CK Editor import to map back from these styles to real stuff.

Navigation
==========

Topics (nodes) are organised in a hierarchy (numerical labels) and may include
a description and custodians (the University role responsible for things in
that area; generally role email addresses for, e.g., HR Directorate). The
documents themselves live on the leaves (generally have a policy, but other
types )

Use book to manage hierarchy, turn the book into a menu, use jQuery for fancy
menu navigation.

Use views to create other navigation types: by title, by type, by audience, by
custodians, by updates.

Normal people navigate to topics, not documents. Links don't go to the
individual node, but to the topic (including other policies, procedures,
etc.). Using anchors.

Use views to display the documents attached to a topic. Views Tabs to add tabs
to a view to display each document type. Views Accordion to display multiple
forms. On empty text, do a search on the old legacy site to show data that
isn't imported yet.

Workflow
========

Each document in the system has, potentially, completely separate sets of
people for editors, reviewers, approvers.

Retain all approved revisions of a document.

Draft -> Approval -> Approved

1. Created (draft)
2. Review (draft)
3. Approval (draft)
4. Approved (published)
5. Draft (a provisional revision)
6. Approval...
7. Approved...

Revisioning, module grants, rules, node access user reference.

Use lots of rules triggered by changes in metadata to change states.

Module Grants allows you to give access to Draft documents to non-authors.
User reference fields for editors, etc. and rules give roles to those users.
Use node-access to actually grant access to the document.

Need to override stuff to ensure that editors of one document cannot see
revisions of other documents.

Rules triggered at edit form nbuild, validation, going to be saved, create,
updating. Most conditioned on workflow state changes.

Access for approver and editor roles differ by workflow state, (approvers are
email when moving into approval, etc.)

Other
=====

Do audit logging with rules. Workflow does this, but it's not using workflow.


