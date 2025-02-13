#pilot analysis (given n=15-30 and effect size =0.7 or 1.6)

power.t.test(n = 30, delta = 0.7, sig.level = 0.05/3,
             type = "paired",
             alternative = "one.sided")
#power = 0.9398209

power.t.test(n = 15, delta = 0.7, sig.level = 0.05/3,
             type = "paired",
             alternative = "one.sided")
#power = 0.6410863

power.t.test(n = 30, delta = 1.6, sig.level = 0.05/3,
             type = "paired",
             alternative = "one.sided")
#power = 1

power.t.test(n = 15, delta = 1.6, sig.level = 0.05/3,
             type = "paired",
             alternative = "one.sided")
#power = 0.999787
