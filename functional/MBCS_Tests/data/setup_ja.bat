@echo off
@echo ##### setting up test string variables #####
@echo TEST_STRING :  a string contains one DBCS word for testing
@echo TEST_STRINGS : a string contains multiple DBCS words for testing

set TEST_STRING=ΆέΌή\¦eXg@AISΚa`
set TEST_STRINGS=Ώ\¦\Ν JiΆΕjKana L:\~P\_`ac|Κ O:ϊUϊhV O:TU@AIS 

@echo TEST_STRING= %TEST_STRING%
@echo TEST_STRINGS= %TEST_STRINGS%


