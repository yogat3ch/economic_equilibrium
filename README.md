---
editor_options: 
  markdown: 
    wrap: 72
---

<h3>Tools for Economic Equity</h3>

<p>Grappling with the challenging question and consequences of income
inequality in the midst of a 30-day meditation retreat, it became clear
that if we value one another as equals and act from a place of mutual
respect, starting from this moment forward, we will eventually create a
more equitable and just economy. Inspired by this simple wish for
greater economic equity in America, the Economic Equilibrium Sliding
Scale was born.</p>

<p>The principle behind this app is a synthesis of the tradition of
offering Dana, the Pali word for generosity. It is a word that connotes
the virtue and a practice of making offerings in the Buddhist tradition.
The livelihood, food, medicine, and housing of the monastic community is
made possible by dana. The practice continues in the West with Dharma
teachers offering their wisdom freely with the intention for it to
liberate others. Those learning from the teacher are encouraged to offer
dana if they find the teachings to be of benefit. Because this practice
of being gifted freely and offering dana in return is foreign to most
practitioners in the Western world, they can sometimes flounder in
trying to find an appropriate amount to offer.</p>

<p>In the spirit of mutual respect and generosity, this app performs the
math to make donations or transactions proportional to one's wealth.</p>

<h4>Methodology</h4>

<p>The app uses economic data from the US Bureau of Labor Statistics
2022 <a
        href="https://www.federalreserve.gov/econres/scfindex.htm" target="_blank">Survey
of Consumer Finances</a> on net worth. The munging of the data is based
on the work of <a
        href="https://www.convey-r.org/1.6-survey-of-consumer-finances-scf.html#survey-of-consumer-finances-scf"
        target="_blank">Guilherme Jacob of Convey-r.org</a>. You can
view the Qmd of the munging here</p>

<h5>Net Worth Percentile Calculator</h5>

<p>BLS data on net worth, stratified by age, is used to create an
empirical cumulative distribution function from which a percentile of
net worth can be rendered. Provide an age, and values for fixed net
worth, fluid net worth, and debts and liabilities to compute the
percentile of net worth for your age. Each question provides guidance on
how to provide the correct value.</p>

<p>A percentile calculation can be saved with a name for use in the
Sliding Scale, but it is not necessary to do so.</p>

<h5>Sliding Scale</h5>

<p>The Sliding Scale uses the percentile of net worth and age of both
participants to calculate a sliding scale for donations or transactions.
The app uses the percentile of the net worth to scale the net worth to
the same age, and then computes a scaling factor based on the magnitude
of difference between the net worths. The scaling factor is multiplied
by the base rate to suggest an amount that is proportional to the total
net worth. It may be surprising what a proportional offering is if you
happen to be the beneficiary of wealth in Western society.</p>

<p>My hope is that this app provides guidance to live in accord with the
heartfelt wish for a world with greater equality, liberty, and
opportunity for everyone</p>
