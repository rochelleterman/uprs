# Testing Notes

Note: This is after I fixed obvious mistakes.

## Summary

**Theme**

- Match: 76
- Partial: 19
- False: 5

**Institutions**

- Match: 95
- Partial: 2
- False: 3

**Action**

- Match: 84
- Partial: 6
- False: 10

## Change Logs / Questions

### Institutions:

In general these are doing pretty well. 

**Changes**:

Added the following:

- Ouagadougou Agreement ['ouagadougou'] 
- Vienna Convention on Consular Relations ['vienna']
- European Convention on the Legal Status of Migrant Workers ['eu-migrant']
- International Convention against the Recruitment, Use, Financing and Training of Mercenaries ['ic-mercenaries']
- United Nations Declaration on the Rights of Indigenous Peoples ['un-indig']

**Issues**:

1. The one that's doing the worst here is "core," as in the core human rights instruments. Maybe we should take it out? 

### Action:

**Changes**:

- I updated the program on the "take measures" code, which is now doing very well. 

**Issues:**

1. 
We got poor agreement on "implement",  "establish", and "report". Should they be modified?

### Theme:

The worst ones here were "foreign-movement", "governance", "post-conflict," and "discrimination". 

**Changes:**

- Added 'poor' to Actors
- Linked institutions to themes:
	- ['women'] = ['CEDAW', 'eu-vaw', 'pol-women']
	- ['sex-violence'] = ['eu-vaw', 'eu-child']
	- ['children'] = ['CRC', 'eu-child']
	- ['torture'] = ['CAT']
	- ['disappearances'] = ['CPED']
	- ['disabilities'] = ['CRPD']
	- ['migrants'] = ['ICMW','eu-migrant']
	- ['race'] = ['ICERD']
	- ['labor'] = ['ILO']
	- ['trafficking'] = ['traffick', 'eu-traff']
	- ['indigenous'] = ['ind169','un-indig']
	- ['domest-movement'] = ['kampala']
	- ['ethnic'] = ['frame-minorities']
	- ['education'] = ['unesco-ed']
	- ['culture'] = ['unesco-expr']
	- ['post-conflict'] = ['ICC']

**Issues:**

1. Recs about "birth registrations” ? Should they be classified as children?

2.  Recs with the phrases “Public education awareness campaigns” and “human rights education” are currently classified as education because they contain the word 'education'. But they're really not about education per se. Should we add a rule dealing with these case or leave them be?

3.  Should all recs classified as sexual violence also be classified as women? For example, if a rec mentions FGM, should it also be classified as dealing with women?

4. Recs mentioning the European Court of Human Rights and ICC were classified as Judiciary because of the "court" . I somewhat fixed this by forcing ‘court’ and ‘tribunal’  to be lowercase, thus eliminating these cases. 

5.  Is ‘sexual harassment’ a case of sexual violence? (I wish we didn't have to decide these things...)

6. Should 'drug trafficking' be counted as trafficking?

7. Statelessness, refugee and citizenship issues is a missing area. Should we add another theme or put these  into an existing theme?

8. For recs about MDGs -- should these be included in the poverty (i.e. the theme on development)?

## Discrepencies

### Institutions

**Partial**

6729: 90.15 Undertake a review of national criminal and immigration legislation to ensure its compatibility with international obligations of the Government, in particular regarding the right to freedom of movement of individuals, in response to the recommendations of the Committees on Civil and Political Rights, on Economic, Social and Cultural Rights and on the Rights of the Child (Mexico);
ERIN: ['CCPR', 'ICESR', 'CRC']
ROCHELLE: ['CCPR']

15952: 62.33. Ratify the Protocol to Prevent, Suppress and Punish Trafficking in Persons, especially Women and children, a protocol to the Convention against Transnational Organized Crime (United States of America);
ERIN: ['traffick']
ROCHELLE: ['CTOC', 'traffick']

**Fail**


23623: 114.62. Take measures to ensure that its national legislation is fully aligned with the international human rights obligations undertaken, including laws affecting the realisation of the freedom of expression and assembly (Finland);
ERIN: ['core']
ROCHELLE: []

30056: 140.153. Review recent legislative changes with a view to fully ensuring freedom of assembly and association, in accordance with international obligations (Austria);
ERIN: ['core']
ROCHELLE: []

30997: 82.13. Continue its efforts to harmonize its national legislation with international human rights instruments (Morocco);
ERIN: ['core']
ROCHELLE: []

### Action

**Partial**

4385: 57.8.1 and take all appropriate measures, in the fields of legislation, implementation and awareness-raising, to tackle domestic violence against women and children (Italy);
ERIN: ['take-measures']
ROCHELLE: ['implement', 'take-measures']

9370: 101.12. Continue to implement the core elements of the Children�s Act, which is a great step forwards in the achievement of the Millennium Development Goals (Angola);
ERIN: ['continue']
ROCHELLE: ['continue', 'implement']

14471: 92.46. Carry out a review of norms and practices relating to freedom of belief in order to harmonize domestic laws with international standards established under ICCPR (Mexico);
ERIN: ['harmonize']
ROCHELLE: ['harmonize', 'establish']

20347: 108.30 Take necessary measures to ensure effective implementation of laws guaranteeing free registration of births nationwide, including by educating families and communities on the importance of birth registration in order to contribute, among other things, to eliminating the practice of early and forced marriage and increase access to education, health care and other public services (Canada);
ERIN: ['take-measures']
ROCHELLE: ['implement', 'take-measures']

36242: 127.65 Continue implementing programmes to improve the way they deal with persons, particularly during security operations and that the Ministry of human rights carry out awareness-raising programmes with the concerned ministries (Bahrain);
ERIN: ['continue']
ROCHELLE: ['continue', 'implement']

38378: 115.100 Take all appropriate measures to enable and facilitate the acquisition of Slovenian citizenship by the erased persons�, paying particular attention to the children of erased persons� in 1992, who are still stateless. Ensure compensation for all erased persons� and, in this regard, review their compensation schemes, on the basis of the amounts and criteria established by the European Court of Human Rights and ensure the implementation of measures to reintegrate erased persons� (France);
ERIN: ['take-measures']
ROCHELLE: ['implement', 'establish', 'take-measures']


**Fail**

1514: 92.2 Finalize various outstanding treaty reports, particularly to the Committee on the Elimination of Discrimination against Women (Cameroon);
ERIN: []
ROCHELLE: ['report']

13289: 98.30. Share its experience and expertise, through multiform and multisectoral cooperation, with the countries of the region that are well behind in achieving Millennium Development Goals, noting that Goals 1 and 2 have been implemented and that Goals 5 and 7 are in the process of being implemented by Jamaica (Haiti);
ERIN: []
ROCHELLE: ['implement']

14548: 61.71. Resort to technical assistance provided by international organizations for the effective implementation of international human rights standards set out in the main international instruments to which it is a party (Mexico);
ERIN: []
ROCHELLE: ['implement', 'assistance']

20158: 115.18. Bring in line the definition of the crime of torture with the Convention against Torture and accede to the Optional Protocol to the Convention against Torture and Other Cruel, Inhuman or Degrading Treatment or Punishment (Uruguay);
ERIN: []
ROCHELLE: ['accede']

21631: 108.58. Provide more resources for implementing the national policies and programmes in favour of social vulnerable groups like women, children, poor people, ethnic minorities and migrants (Viet Nam);
ERIN: []
ROCHELLE: ['implement']

25208: 126.27 Incorporate into its legislation measures of prompt and effective cooperation with the International Criminal Court, as well as, obligations to investigate and prosecute in its territory crimes established in the Rome Statute (Costa Rica);
ERIN: []
ROCHELLE: ['establish']

25401: 131.46 In line with its previously accepted UPR recommendation adopt legislation prohibiting FGM and continue to strengthen awareness raising on this issue (Hungary);
ERIN: []
ROCHELLE: ['continue']

27705: 124.135. Intensify the implementation of the Second Plan of Action combating violence against women, in particular for women in a vulnerable situation (Chile);
ERIN: []
ROCHELLE: ['implement']

32415: 114.42 Take steps to complete the establishment of the National Preventive Mechanism in accordance with OP-CAT (Ghana);
ERIN: []
ROCHELLE: ['establish']

37015: 108.69 Adopt a national plan of action to combat sexual and gender-based violence, criminalize marital rape as a matter of urgency and strengthen laws and their implementation on trafficking in persons (Ireland);
ERIN: []
ROCHELLE: ['implement']

### Theme

**Partial**

962: 56.21 To protect the children and families of migrants and refugees (Algeria, Ecuador) and to accede to the International Convention on Protection of the Rights of All Migrant Workers and Members of Their Families. (Algeria, Ecuador and Egypt) );
ERIN: ['children', 'migrants']
ROCHELLE: ['children', 'labor', 'migrants']

1514: 92.2 Finalize various outstanding treaty reports, particularly to the Committee on the Elimination of Discrimination against Women (Cameroon);
ERIN: ['women']
ROCHELLE: ['discrimination', 'women']

1836: 77.7 Put in place a special law that will take into consideration the land rights of the pygmy� communities (Holy See). );
ERIN: ['land', 'indigenous']
ROCHELLE: ['ethnic', 'land']

3155: 92.5 Improve the legislative and judicial sectors of Jordan particularly in the areas of gender mainstreaming, sexual harassment and economic exploitation of children (Nigeria);
ERIN: ['children', 'women', 'sex-violence', 'poverty']
ROCHELLE: ['children', 'judiciary', 'poverty', 'women']

6729: 90.15 Undertake a review of national criminal and immigration legislation to ensure its compatibility with international obligations of the Government, in particular regarding the right to freedom of movement of individuals, in response to the recommendations of the Committees on Civil and Political Rights, on Economic, Social and Cultural Rights and on the Rights of the Child (Mexico);
ERIN: ['domest-movement', 'children']
ROCHELLE: ['culture', 'children', 'domest-movement', 'migrants']

6865: 91.34 Take effective measures against the practice of forced labour, including child labour and join ILO (Italy);
ERIN: ['children', 'labor']
ROCHELLE: ['children', 'labor', 'trafficking']

12177: 106.12. Continue commitment to human rights through the ratification of the International Convention on the Protection of the Rights of All Migrant Workers and Members of Their Families in accordance with recommendation 1737 of 17 March 2006, adopted by the Parliamentary Assembly of the Council Europe, of which Denmark is a member (Algeria);
ERIN: ['migrants']
ROCHELLE: ['labor', 'migrants']

18035: 77.1. Ratify the International Convention for the Protection of All Persons from Enforced Disappearance and the Rome Statute of International Criminal Court (France);
ERIN: ['disappearances']
ROCHELLE: ['disappearances', 'post-conflict']

19110: 87.18. Step up measures to curb the incidence of drug and alcohol abuse by children including through intensive public education awareness campaigns (Malaysia);
ERIN: ['children']
ROCHELLE: ['education', 'children']

19925: 129.30 Review and eliminate laws that discriminate against women, especially in issues of inheritance, and bring in line with international standards (Mexico);
ERIN: ['women', 'property']
ROCHELLE: ['discrimination', 'women', 'property']

20347: 108.30 Take necessary measures to ensure effective implementation of laws guaranteeing free registration of births nationwide, including by educating families and communities on the importance of birth registration in order to contribute, among other things, to eliminating the practice of early and forced marriage and increase access to education, health care and other public services (Canada);
ERIN: ['education', 'health', 'children', 'sex-violence']
ROCHELLE: ['education', 'health', 'sex-violence', 'poverty']

21631: 108.58. Provide more resources for implementing the national policies and programmes in favour of social vulnerable groups like women, children, poor people, ethnic minorities and migrants (Viet Nam);
ERIN: ['women', 'children', 'poverty', 'ethnic', 'migrants']
ROCHELLE: ['children', 'poor', 'ethnic', 'women', 'migrants']

23740: 97.36. In the realm of the new criminal procedure code, establish an independent mechanism for the investigation of alleged cases of torture by officers of law-enforcement agencies independent from the Ministry of the Interior and the Prosecutor�s Office (Estonia);
ERIN: ['torture', 'police']
ROCHELLE: ['police', 'torture', 'judiciary']

24713: 102.91. Take measures to prevent and sanction police harassment and torture, including through human rights education and training modules (Costa Rica);
ERIN: ['police', 'torture']
ROCHELLE: ['education', 'police', 'torture']

25401: 131.46 In line with its previously accepted UPR recommendation adopt legislation prohibiting FGM and continue to strengthen awareness raising on this issue (Hungary);
ERIN: ['sex-violence', 'women']
ROCHELLE: ['sex-violence']

32473: 114.100 Undertake awareness-raising campaigns to sensitize law enforcement officials and the judiciary on violence against women and girls, within the framework of the new Law 348, the Comprehensive Act on guaranteeing a life free of violence for women (Belgium);
ERIN: ['police', 'judiciary', 'women', 'children', 'sex-vioelnce']
ROCHELLE: ['children', 'police', 'sex-violence', 'judiciary', 'women']

33599: 127.152 Continue the efforts to facilitate the registration of births and create awareness of the importance of this procedure, which allows access to all other rights and basic services such as education and health (Turkey);
ERIN: ['education', 'health', 'children']
ROCHELLE: ['education', 'health']

34682: 166.183 Ensure due process of law for detainees, because a fair and independent judicial system is a fundamental pillar of a future democratic and stable Egypt (Canada);
ERIN: ['prisoners', 'judiciary']
ROCHELLE: ['judiciary', 'self-determ']

37015: 108.69 Adopt a national plan of action to combat sexual and gender-based violence, criminalize marital rape as a matter of urgency and strengthen laws and their implementation on trafficking in persons (Ireland);
ERIN: ['sex-violence', 'trafficking']
ROCHELLE: ['sex-violence', 'women', 'trafficking']

**Fail**

25208: 126.27 Incorporate into its legislation measures of prompt and effective cooperation with the International Criminal Court, as well as, obligations to investigate and prosecute in its territory crimes established in the Rome Statute (Costa Rica);
ERIN: ['governance']
ROCHELLE: ['post-conflict']

27941: 136.155. Acknowledge the right of all Palestinian refugees to return to their homeland, as enshrined in the Fourth Geneva Convention (Pakistan);
ERIN: ['land']
ROCHELLE: ['migrants']

30056: 140.153. Review recent legislative changes with a view to fully ensuring freedom of assembly and association, in accordance with international obligations (Austria);
ERIN: ['speech']
ROCHELLE: ['civil-so']

32085: 135.10 Make further efforts to ratify and fully align its national legislation with the Rome Statute of the International Criminal Court (Republic of Korea);
ERIN: []
ROCHELLE: ['post-conflict']

38378: 115.100 Take all appropriate measures to enable and facilitate the acquisition of Slovenian citizenship by the erased persons�, paying particular attention to the children of erased persons� in 1992, who are still stateless. Ensure compensation for all erased persons� and, in this regard, review their compensation schemes, on the basis of the amounts and criteria established by the European Court of Human Rights and ensure the implementation of measures to reintegrate erased persons� (France);
ERIN: ['foreign-movement', 'ethnic']
ROCHELLE: ['children']