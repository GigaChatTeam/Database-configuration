# Description of basic structure of permissions identification

***

**All rights are identified with 4 non-negative integer values.**

First two numbers indentify the permission category, and remaining two have unique meaning based on category.**

Possible values for first number:
* `0`: System permissions. Their assignment is determined automatically.
* `1`: *Reserved*
* `2`: Channel permissions
* `3`: *Reserved*
* `4`: Communities permissions
* `5`: *Reserved*

Possible values for second value:
* `0`: Normal capabilities of ordinary users
* `1`: Administrative capabilities
* `2`: Bots-related