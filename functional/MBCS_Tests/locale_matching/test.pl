#!/usr/bin/perl
################################################################################
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
################################################################################
#
use Test::Simple tests => 5;
use FindBin;

$base = $FindBin::Bin."/";
print "base ".$base."\n";
$jar = "-cp ".$base."locale_matching.jar";

$OS=$^O; #OS name
chomp($OS);
$SYSENC=`locale charmap`;
chomp($SYSENC);
$lang = $ENV{LANG};
$i = index($lang,".");
if ($i == -1) {
    $i = length($lang);
}
$lang = substr($lang, 0, $i);
$FULLLANG = $OS."_".$lang.".".$SYSENC;

if ($FULLLANG eq "aix_Ja_JP.IBM-943" ||
    $FULLLANG eq "aix_ja_JP.IBM-eucJP" ||
    $FULLLANG eq "aix_JA_JP.UTF-8" ||
    $FULLLANG eq "aix_ko_KR.IBM-eucKR" ||
    $FULLLANG eq "aix_KO_KR.UTF-8" ||
    $FULLLANG eq "aix_zh_CN.IBM-eucCN" ||
    $FULLLANG eq "aix_Zh_CN.GB18030" ||
    $FULLLANG eq "aix_ZH_CN.UTF-8" ||
    $FULLLANG eq "aix_zh_TW.IBM-eucTW" ||
    $FULLLANG eq "aix_Zh_TW.big5" ||
    $FULLLANG eq "aix_ZH_TW.UTF-8" ||
    $FULLLANG eq "aix_ja_JP.UTF-8" ||
    $FULLLANG eq "aix_ko_KR.UTF-8" ||
    $FULLLANG eq "aix_zh_Hans_CN.UTF-8" ||
    $FULLLANG eq "aix_zh_Hant_TW.UTF-8" ||
    $FULLLANG eq "linux_ja_JP.UTF-8" ||
    $FULLLANG eq "linux_ko_KR.UTF-8" ||
    $FULLLANG eq "linux_zh_CN.UTF-8" ||
    $FULLLANG eq "linux_zh_TW.UTF-8"){}
else {
    ok(true,"skip");
    ok(true,"skip");
    ok(true,"skip");
    ok(true,"skip");
    ok(true,"skip");
    print "SKIPPED! ${FULLLANG} is not supported. ";
    exit(0);
}

my @list=(
"LocaleFilterTest1",
"LocaleFilterTest2",
"LocaleFilterTest3",
"LocaleLookupTest1",
"LocaleLookupTest2"
);

foreach my $target(@list){
    my $flag = false;
    system($ENV{'JAVA_BIN'}."/java ".$jar." ".$target." > ".$target.".log 2>&1");
    open(DATA, "< ".$target.".log");
    while (my $line = <DATA>) {
        chomp($line);
        if ($line =~ /Passed/) {
            $flag=true;
        }
    }
    close(DATA);
    ok( $flag eq true, $target);
}

