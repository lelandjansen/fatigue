# Fatigue
Pilot and engineer fatigue self-assessment app

![Fatigue app icon][app-icon]

**A full write-up is also available on my [website][lelandjansen-website].**

Evaluate your fatigue using the International Airborne Geophysics Safety
Association’s self-assessment tool. Complete a short questionnaire to compute
your risk score and determine if you are fit to work or fly.

**Features**
* Pilot and engineer questionnaires.
* Daily reminders to complete the self-assessment.
* Quickly share risk scores with your supervisor.

### [Download on the App Store][app-store-download]

**Details**
* Native iPhone application for geophysical-survey pilots to self-assess their
  fatigue level.
* Features programmatic UI with intuitive data entry mechanism.
* Employs graph theory algorithms and data structures to represent
  questionnaire.
* Commended for attention to detail and high level of polish.

![Fatigue iPhones][fatigue-iphones]

[The International Airborne Geophysics Safety Association][iagsa] (IAGSA)
promotes the safe operation of helicopters and fixed-wing aircraft on airborne
geophysical surveys. Pilot and engineer fatigue is one of the safety risks they
wish to mitigate. IAGSA developed a [flight card][flight-card] where pilots and
engineers tally up their responses to questions to determine their risk score.
However, this solution has poor adoption amongst users. Fatigue implements the
same logic as the flight card but improves on it in four areas: The app offers
greater convenience than the flight card, has a reminder feature so users don't
forget to complete the self-assessment, automatically tallies their risk score,
and finally implements a convenient method for users to report this risk score
to their supervisor.

### Screenshots

|![Screenshot 0][screenshot-0]|![Screenshot 1][screenshot-1]|![Screenshot 2][screenshot-2]|
|-|-|-|
|![Screenshot 3][screenshot-3]|![Screenshot 4][screenshot-4]||

### Graph theory
Fatigue represents the questionnaire's question sequence as a directed graph.
This is necessary because an answer to one question determines the next question
that is asked. For example, answering "No" to "Have you been on-site for less
than three full days?" allows the user to bypass a question related to time
zones. The app performs a longest-path computation each time the user responds
to a question to determine the most number of questions the user will need to
answer. This is shown by the `UIPageControl` at the bottom of the screen.

![Graph theory][graph-theory]

![Fatigue iPhone and iPad][fatigue-iphone-ipad]

[app-icon]: resources/app-icon.png
[lelandjansen-website]: https://www.lelandjansen.com/project/fatigue
[app-store-download]: http://itunes.apple.com/app/fatigue/id1211561428
[fatigue-iphones]: resources/fatigue-iphones.png
[iagsa]: http://www.iagsa.ca/
[flight-card]: resources/flight-card.pdf
[screenshot-0]: resources/screenshot-0.png
[screenshot-1]: resources/screenshot-1.png
[screenshot-2]: resources/screenshot-2.png
[screenshot-3]: resources/screenshot-3.png
[screenshot-4]: resources/screenshot-4.png
[graph-theory]: resources/graph-theory.gif
[fatigue-iphone-ipad]: resources/fatigue-iphone-ipad.png
