## SPDX-License-Identifier: BSD-2-Clause
## Copyright (c) 2019, Konrad Weihmann

## This class provides the configuration for blacklisting modules from certain recipes
## All configuration is described through space-separated regular expression
SCA_BLACKLIST ?= ".*-native .*-cross nativesdk-.*"
SCA_BLACKLIST_bandit ?= "linux-.*"
SCA_BLACKLIST_bitbake ?= ""
SCA_BLACKLIST_cbmc ?= "linux-.* busybox"
SCA_BLACKLIST_configcheck ?= ""
SCA_BLACKLIST_cppcheck ?= "linux-.*"
SCA_BLACKLIST_cpplint ?= "linux-.*"
SCA_BLACKLIST_darglint ?= ""
SCA_BLACKLIST_dennis ?= "linux-.*"
SCA_BLACKLIST_detectsecrets ?= "linux-.*"
SCA_BLACKLIST_flake8 ?= ""
SCA_BLACKLIST_flawfinder ?= ""
SCA_BLACKLIST_flint ?= "linux-.*"
SCA_BLACKLIST_gcc ?= ""
SCA_BLACKLIST_gixy ?= ""
SCA_BLACKLIST_jsonlint ?= ""
SCA_BLACKLIST_kconfighard ?= ""
SCA_BLACKLIST_looong ?= "linux-.*"
SCA_BLACKLIST_lynis ?= ""
SCA_BLACKLIST_multimetric ?= ""
SCA_BLACKLIST_mypy ?= "linux-.*"
SCA_BLACKLIST_nixauditor ?= ""
SCA_BLACKLIST_oelint ?= ""
SCA_BLACKLIST_pscan ?= ""
SCA_BLACKLIST_pyfindinjection ?= ""
SCA_BLACKLIST_pylint ?= "linux-.*"
SCA_BLACKLIST_pysymcheck ?= ""
SCA_BLACKLIST_pytype ?= "linux-.*"
SCA_BLACKLIST_rats ?= ""
SCA_BLACKLIST_ropgadget ?= "linux-.*"
SCA_BLACKLIST_safety ?= ""
SCA_BLACKLIST_setuptoolslint ?= ""
SCA_BLACKLIST_shellcheck ?= ""
SCA_BLACKLIST_sparse ?= ""
SCA_BLACKLIST_splint ?= "linux-.*"
SCA_BLACKLIST_systemdlint ?= ""
SCA_BLACKLIST_tlv ?= "linux-.*"
SCA_BLACKLIST_tscanscode ?= "linux-.*"
SCA_BLACKLIST_upc ?= ""
SCA_BLACKLIST_vulture ?= ""
SCA_BLACKLIST_xmllint ?= ""
SCA_BLACKLIST_yamllint ?= ""
SCA_BLACKLIST_zrd ?= "linux-.*"
SCA_BLAckLIST_bashate ?= ""
SCA_BLAckLIST_checkbashism ?= ""

inherit sca-helper

# Some yocto version don't know this var
BASE_DEFAULT_DEPS ?= "virtual/${TARGET_PREFIX}gcc virtual/${TARGET_PREFIX}compilerlibs virtual/libc"

def sca_is_module_blacklisted(d, tool):
    import re
    pn = d.getVar("PN", True)
    matches = [x for x in (d.getVar("SCA_BLACKLIST", True) or "").split(" ") if x]
    matches += [x for x in (d.getVar("SCA_BLACKLIST_{}".format(tool.replace("-", "_")), True) or "").split(" ") if x]
    _pns = [re.match(x, pn) for x in matches]
    _def_deps = [x for x in d.getVar("BASE_DEFAULT_DEPS", True).split(" ")]
    _prov = [x for x in d.getVar("PROVIDES", True).split(" ")]
    return any(_pns + intersect_lists(d, _def_deps, _prov))
