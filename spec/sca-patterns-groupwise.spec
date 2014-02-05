# spec file for package sca-patterns-groupwise
#
# Copyright (C) 2014 SUSE LLC
#
# This file and all modifications and additions to the pristine
# package are under the same license as the package itself.
#

# norootforbuild
# neededforbuild

%define sca_common sca
%define patdirbase /usr/lib/%{sca_common}
%define patdir %{patdirbase}/patterns
%define patuser root
%define patgrp root
%define mode 544
%define category GroupWise

Name:         sca-patterns-groupwise
Summary:      Supportconfig Analysis Patterns for GroupWise
URL:          https://bitbucket.org/g23guy/sca-patterns-groupwise
Group:        Documentation/SuSE
License:      GPL-2.0
Autoreqprov:  on
Version:      1.3
Release:      2
Source:       %{name}-%{version}.tar.gz
BuildRoot:    %{_tmppath}/%{name}-%{version}
Buildarch:    noarch
Requires:     sca-patterns-base

%description
Supportconfig Analysis (SCA) appliance patterns to identify known
issues relating to all versions of GroupWise

Authors:
--------
    Jason Record <jrecord@suse.com>

%prep
%setup -q

%build

%install
pwd;ls -la
rm -rf $RPM_BUILD_ROOT
install -d $RPM_BUILD_ROOT/%{patdir}/%{category}
install -m %{mode} patterns/%{category}/* $RPM_BUILD_ROOT/%{patdir}/%{category}

%files
%defattr(-,%{patuser},%{patgrp})
%dir %{patdirbase}
%dir %{patdir}
%dir %{patdir}/%{category}
%attr(%{mode},%{patuser},%{patgrp}) %{patdir}/%{category}/*

%clean
rm -rf $RPM_BUILD_ROOT

%changelog

