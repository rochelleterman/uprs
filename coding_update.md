### Summary:

1. Three tags: Institutions, Actions, and Themes
2. 99.87 of the recs have been tagged with either an institution or a theme.
3. Institutions are easier to tag than themes

### Concerns - Questions

1. A lot of the recs are about generic human rights instruments - e.g. "128.26. Endeavour to ratify without delay all international human rights statutes that it has yet to sign (Nigeria)". Difficult to capture.
2. A lot of recs are about generic human rights violations -- also difficult to code. i.e. "Take effective, predominantly legislative steps to protect the rights of persons deprived of their liberty"
3. Some recs are positive (i.e. complimenting the country) and others are critical. We got some of this through the "continue" action but I think it would be good to code this manually and then try a machine learning algorithm to catch the rest.

### Institutions

1. Convention against Torture
2. ICCPR
3. ICESR
4. CEDAW (women's convention)
5. CRC (child's convention)
6. ICERD (elimination of racial discrimination)
7. ILO (int'l labor organization)
8. ICC / Rome Statute
9. Paris Principles
10. CPED (convention on protection of persons from enforced disappearances)
11. ICMW (migrant worker's convention)
12. CRPD (convention on rights of people with disabilities)
13. Genocide Convention
14. (UNESCO) Convention against Discrimination in Education
15. 1951 Convention relating to the Status of Refugees
16. Convention against Transnational Organized Crime
17. Convention against Corruption
18. UNESCO Convention on the Protection and Promotion of Diversity of the Cultural Expressions
19. 1961 Convention on the Reduction of Statelessness
20. 1954 Convention Relating to the Status of Stateless Persons
21. Geneva Conventions
22. Hague Convention (on intercountry adoptions)
23. Ottawa Convention (on landmines)
24. Europe Convention on Preventing and Combating Violence against Women and Domestic Violence
25. International Coordinating Committee of National Institutions for the
26. Promotion and Protection of Human Rights
27. Europe Convention on the Protection of Children against Sexual Exploitation and Sexual Abuse
28. EU Framework Convention for the Protection of National Minorities
29. EU Convention on Action against Trafficking in Human Beings
30. American Convention on Human Rights
31. European Convention of Human Rights
32. Kampala Convention of Human Rights


### Action

1. **ratify** = ['ratify']
2. **accede** = ['accede']
3. **sign** = ['sign']
4. **implement** = ['implement']
5. **establish** = ['establish']
6. **continue** = ['continue']
7. **take-measures** = ['take measures']
8. **harmonize** = ['harmonize']
9. **report** = ['to report','reporting','reports']
10. **party** = ['party to']
11. **withdraw** = ['withdraw']

### Theme

**Note:** The weird spellings are purposful. 

####physical integrity rights

**torture** = ['torture', 'inhuman degrading treatment', 'corporal punishment', 'stoning', 'amputation', 'caning', 'whipping']

**trafficking** = ['slavery', 'forced labor', 'forced labour', 'traffick', 'abduct', 'kidnap']

**prison** = ['prison', 'police', 'interrogation', 'detainees', 'security force', 'security personnel', 'security official', 'detention', 'detained', 'law enforc', 'incarceration', 'solitary confinement']

**disappearances** = ['disappearances','disappeared']

**death-pen** = ['death penalty', 'extrajudicial', 'capital punishment', 'death sentence', 'executions', 'capital sentence']

####political rights####

**migration** ['migration', 'migrant', 'refugee', 'displaced', 'asylum', 'displacements', 'idps', 'eviction', 'statelessness']

**speech** = ['speech', 'expression', 'journalis', 'opinion', ' press ', ' media', 'insult law', 'defamation', 'political dissent', 'newspapers']

**religion** = ['religio', 'church', 'muslim', 'blasphemy', 'apostasy']

**judiciary** = ['judiciary', 'judicial', 'fair trial', 'court', 'judge', 'defendants', 'prosecutor', 'lawyer', 'legal representation', 'tribunal', 'legal aid', "due process"]

**privacy** = ['privacy']

#### soc, cul, econ. rights

**poverty** = ['poverty','social security','pension','social safety net']

**health** = ['health','hospital','doctor','medical','disease']

**hiv** = ['hiv']

**food** = ['food','hungry']

**infrastructure** = ['water','sanitation','housing','roads','right development','living standard','homeless']

**labor** = [' labor','labour','strike','unions','worker','employment']

**education** = ['education','illiter','school']

**property** = ['property','properties']

**land** = ['land rights']

**culture** = ['cultural rights','cultural values','traditions']

#### vuln. populations

**children** = ['child', 'juvenile', 'minors', 'girl', 'minimum age', 'age criminal responsibility']

**lgbt** = ['lgbt', 'lesbian', 'gay', 'homosexual', 'transsexual', 'sexual orientation', 'gender identity', 'consensual sex', 'same-sex', 'same sex', 'homophobia', 'between consenting adults']

**ethnic** = ['tribal area', 'vulnerable population', 'roma', 'ethnic', 'minorit', 'xenophobi']

**indigenous** = ['indigenous', 'aboriginal']

**race** = ['race', 'racial', 'racism']

**disabilities** = ['disabilit', 'disabled']

**women** = ['women', 'gender', 'misogyn', 'widows', 'girl']

**sex-violence** = ['domestic violence', 'sexual violence', 'rape', 'domestic abuse', 'sexual abuse', prostitut', 'gender-based violence', 'violence against women', 'prostitut']

**discrimination** = ['discriminat', 'advancement', 'stereotyp', 'attitude', 'role responsibilit', 'equal']

**harm-trad** = ['fgm', 'genital', 'early marriage', 'forced marriage', 'harmful traditional practices', 'sexual mutilation', 'polygamy','witch']

**reproductive** = ['reproductive', 'abortion', 'birth control', 'maternal', 'family planning']

**elderly** = ['elderly']

#### political conflict

**conflict** = ['truth commission', 'reconstruction', 'post-conflict', 'reconciliation', 'civil war', 'post conflict', 'civil conflict', 'armed conflict']

**governance** = ['good governance', 'rule law', 'stability', 'public governance']

**corruption** = ['corruption', 'bribary', 'bribe', 'bribing', 'extortion']

**environment** = ['environment', 'pollution', 'climate change']

**democ** = ['democrat', 'election']

**self-determ** =['self-determination', 'self determination']

**socialism** = ['socialism','communism']

**civil-so** = ['civil society','rights defenders', 'charities', 'protest', 'activist', 'demonstrator', 'freedom assembly', 'freedom association', 'free association', 'free assembly', 'demonstrations','NGO']

**terrorism** = ['terroris']

**crime-humanity** = ['war crime','crimes humanity','genocide','massacre']

#### human rights violations

**impunity** = ['impunity', 'immunity from prosecution']


