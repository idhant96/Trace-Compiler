
**Grammar**

program -&gt; execute block

block -&gt; { declarationList statementList }

declarationList -&gt; declaration ; declarationList

declarationList -&gt; \[\]

declaration -&gt; numberDeclaration

declaration -&gt; booleanDeclaration

declaration -&gt; stringDeclaration

numberDeclaration -&gt; number var\_name = number\_expr

numberDeclaration -&gt; number var\_name

booleanDeclaration -&gt; bool var\_name = bool\_expr

booleanDeclaration -&gt; bool var\_name

stringDeclaration -&gt; string var\_name = string\_expr

stringDeclaration -&gt; string var\_name

statementList -&gt; statement ; statementList

statementList -&gt; \[\]

statement -&gt; print\_statement

statement -&gt; var\_name = number\_expr

statement -&gt; var\_name = bool\_expr

statement -&gt; var\_name = string\_expr

statement -&gt; var\_name ++

statement -&gt; var\_name --

statement -&gt; loopStatement

statement -&gt; conditionalStatement

print\_statement -&gt; print( string\_expr )

loopStatement -&gt; for ( declaration ; bool\_expr ; statement ) block

loopStatement -&gt; for var\_name in range ( number number ) block

loopStatement -&gt; while( bool\_expr ) block

conditionalStatement -&gt; if ( bool\_expr ) then block

conditionalStatement -&gt; if ( bool\_expr ) then block else then block

conditionalStatement -&gt; if ( bool\_expr ) then block else
conditionalStatement

number\_expr -&gt; level\_1

number\_expr -&gt; number\_expr + level\_1

number\_expr -&gt; number\_expr - level\_1

level\_1 -&gt; level\_1 \* level\_2

level\_1 -&gt; level\_1 / level\_2

level\_1 -&gt; level\_2

level\_2 -&gt; ( number\_expr )

level\_2 -&gt; number

level\_2 -&gt; var\_name

bool\_expr -&gt; true

bool\_expr -&gt; false

bool\_expr -&gt; not bool\_expr

bool\_expr -&gt; bool\_expr and bool\_expr

bool\_expr -&gt; bool\_expr or bool\_expr

bool\_expr -&gt; number\_expr = = number\_expr

bool\_expr -&gt; bool\_expr = = bool\_expr

bool\_expr -&gt; string\_expr = = string\_expr

bool\_expr -&gt; number\_expr ! = number\_expr

bool\_expr -&gt; bool\_expr ! = bool\_expr

bool\_expr -&gt; string\_expr ! = string\_expr

bool\_expr -&gt; number\_expr &gt; number\_expr

bool\_expr -&gt; number\_expr &lt; number\_expr

bool\_expr -&gt; number\_expr &gt; = number\_expr

bool\_expr -&gt; number\_expr &lt; = number\_expr

string\_expr -&gt; string

var\_name -&gt; X {atom(X)}

number -&gt; X {number(X)}

string -&gt; X {string(X)}


**Description**

Program begins with the keyword “execute”.

It is followed by a block. A block starts and ends with curly braces and
comprises declarations, statements.

The user can declare variables of type: Number, Boolean or string.

**Data types supported in our language:**

**Number:** represents integer or floating point number. Default Value:
0

**Boolean:** true or false. Default value: false

**String:** It is a sequence of characters enclosed within double
quotes. Default value: “” (Empty)

**Arithmetic Operators:**

1.  Modulus: %

2.  Multiplication: \*

3.  Division: /

4.  Addition: +

5.  Subtraction: -

6.  Increment: ++

7.  Decrement: --

**Arithmetic Operator Precedence:**

1.  Parenthesis: ()

2.  Modulus, Multiplication, Division: %, \*, /

3.  Addition, Subtraction: +, -

**Relational Operators:**

1.  Lesser : “&lt;”

2.  Greater : “&gt;”

3.  Less than or equal to : “&lt;=”

4.  Greater than or equal to : “&gt;=”

5.  Not equal to : “! = “

6.  Equality check : “==”

**Logical Operators:**

1.  and

2.  or

3.  Not

**Assignment Operator: **

1.  Equals: “=”

**Declarations**

A block can have zero or more number of declaration statements. Our
program is strongly typed and data type has to be explicitly mentioned.
Have a signal declaration in a line. Every declaration should end with
semicolon “;”

Example of declaration.

1.  number a = 10;

2.  number a;

3.  bool isValid = true;

4.  string name;

**Conditional Statement**

The “if (condition) then” statement executes a block if the condition
evaluates to true. If the condition evaluates to false, the block
following the “else then” gets executed. This is used to execute
different blocks based on different conditions. The keyword “else if
(condition) then” is used to check for another condition when the “if
(condition) then” condition evaluates to false.

Examples of conditionals:

1.  if (x == 2 ) then { x = x + 2 }

> else then { x = x + 1}

1.  if (x == 2) then {x = x + 2}

> else if (x == 3) then { x = x + 1 }
>
> else then { x = x + 3}

1.  if (x == 2) then { x = x + 2 }

**Statement Lists:**

Statement Lists is the part which follows Block. Statement List part can
contain one or more of many of the types of statements.

Different kinds of statements: Print statement, Assignment statements,
Loop Statement List, Conditional Statement List.

**Print statement:**

The print statement is used to write to the screen. The print statements
start with a ‘print’ keyword and then followed by the string to be
printed inside ‘()’.

Example: print(“Hello World!”)

**Loop statement: **

**Simple for pattern**

A loop statement starts with “for” followed by parenthesis (). Inside
the parentheses we have three parts which are namely “declaration”,
“conditional expression” and “increment statement”. In declaration we
would declare the iterable variable, later the bool\_expr will evaluate
the iteration limit for the loop and lastly the update statement will
update the iterable variable.

Examples of Simple for pattern :

> for(i=0; i&lt;10; i=i+1;) {
>
> i = i+ 1;
>
> }

**Range pattern**

A loop statement starts with “for” followed by iterable variable
initialization.In declaration we would declare the iterable variable,
and range of iterable values the iterable variable can take. The range
function generates a list of iterable values which the iterable variable
can take in each iteration.

Examples of Simple for pattern :

> For i in range(1,10) {
>
> i = i+ 1;
>
> }

**Simple While Loop**

The while loop will begin with the “while” keyword followed by
parenthesis (). Inside the parentheses the bool\_expr, which gets
executed each time the while loop is called. The loop continues until
bool\_expr return true and ends when it returns false.

Examples of Simple for pattern :

> while (i &lt; 10){
>
> i = i+ 1;
>
> }

**Assignment Statement : **

This statement is used to set a value given to a variable.

Examples of assignment statement :

1.  X = 5;

2.  X = “Hello World!”;

3.  X = “true”;

bool\_expr -&gt; true

bool\_expr -&gt; false

bool\_expr -&gt; not bool\_expr

bool\_expr -&gt; bool\_expr and bool\_expr

bool\_expr -&gt; bool\_expr or bool\_expr

bool\_expr -&gt; number\_expr = = number\_expr

bool\_expr -&gt; bool\_expr = = bool\_expr

bool\_expr -&gt; string\_expr = = string\_expr

bool\_expr -&gt; number\_expr ! = number\_expr

bool\_expr -&gt; bool\_expr ! = bool\_expr

bool\_expr -&gt; string\_expr ! = string\_expr

bool\_expr -&gt; number\_expr &gt; number\_expr

bool\_expr -&gt; number\_expr &lt; number\_expr

bool\_expr -&gt; number\_expr &gt; = number\_expr

bool\_expr -&gt; number\_expr &lt; = number\_expr

Boolean expression:

The boolean expression can simply evaluate to be a ‘true’ or ‘false’
value.

**‘not’ boolean operator:** This operator is used to negate the value of
a boolean expression.

Syntax : ‘not’ keyword followed by a boolean expression.

**‘and’ boolean operator:** This operator is used to check whether both
value of the two boolean expression evaluates to ‘true’

Syntax : boolean expression1 followed by ‘and’ keyword followed by a
boolean expression2.

**‘Or’ boolean operator:** This operator is used to check whether either
value of the two boolean expression evaluates to ‘true’

Syntax : boolean expression1 followed by ‘or’ keyword followed by a
boolean expression2.

**‘equality’ boolean operator:** This operator is used to check whether
the values of two expressions(numeric/boolean/string) are equal.

Syntax : expression1 followed by ‘ ==’ keyword followed by expression2.

**Example Program:**

> execute {
>
> number a;
>
> bool isValid = false;
>
> string name = “team22”;
>
> if(name == “team22” ) then {
>
> print(“team 22”);
>
> } else then {
>
> print(“not eam 22”);
>
> }
>
> for( number i = 0; i &lt; 22 ; i++ ) {
>
> a = i;
>
> print(“hi”);
>
> }
>
> a = (20 % 5) + 2;
>
> isValid = true;
>
> while(isValid) {
>
> int b = 10;
>
> print(“isValid”);
>
> isValid = false;
>
> }
>
> print(“This is a sample program”);

}
