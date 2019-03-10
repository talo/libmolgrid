import pytest
import molgrid
import pybel
import os
from pytest import approx

def test_gninatyping():
    m = pybel.readstring('smi','c1ccccc1CO')
    m.addh()
    t = molgrid.GninaIndexTyper()
    assert t.num_types() == 28
    names = list(t.get_type_names())
    assert names[2] == 'AliphaticCarbonXSHydrophobe'
    typs = [t.get_atom_type(a.OBAtom) for a in m.atoms]
    assert len(typs) == 16
    acnt = 0
    ccnt = 0
    ocnt = 0
    hcnt = 0
    phcnt = 0
    for t,r in typs:
        if names[t] == 'AromaticCarbonXSHydrophobe':
            acnt += 1
            assert r == approx(1.9)
        if names[t] == 'AliphaticCarbonXSNonHydrophobe':
            ccnt += 1
            assert r == approx(1.9)
        if names[t] == 'OxygenXSDonorAcceptor':
            ocnt += 1
            assert r == approx(1.7)
        if names[t] == 'Hydrogen':
            hcnt += 1
            assert r == approx(.37)
        if names[t] == 'PolarHydrogen':
            phcnt += 1
            assert r == approx(.37)
    assert acnt == 6
    assert ccnt == 1
    assert ocnt == 1
    assert phcnt == 1
    assert hcnt == 7
    
    #check covalent rdius
    t = molgrid.GninaIndexTyper(True)
    typs = [t.get_atom_type(a.OBAtom) for a in m.atoms]
    assert len(typs) == 16
    acnt = 0
    ccnt = 0
    ocnt = 0
    hcnt = 0
    phcnt = 0
    for t,r in typs:
        if names[t] == 'AromaticCarbonXSHydrophobe':
            acnt += 1
            assert r == approx(0.77)
        if names[t] == 'AliphaticCarbonXSNonHydrophobe':
            ccnt += 1
            assert r == approx(0.77)
        if names[t] == 'OxygenXSDonorAcceptor':
            ocnt += 1
            assert r == approx(.73)
        if names[t] == 'Hydrogen':
            hcnt += 1
            assert r == approx(.37)
        if names[t] == 'PolarHydrogen':
            phcnt += 1
            assert r == approx(.37)
    assert acnt == 6
    assert ccnt == 1
    assert ocnt == 1
    assert phcnt == 1
    assert hcnt == 7    

def test_elementtyping():
    m = pybel.readstring('smi','c1ccccc1CO')
    m.addh()
    t = molgrid.ElementIndexTyper(17)
    assert t.num_types() == 17
    names = list(t.get_type_names())
    assert names[2] == 'Helium'
    typs = [t.get_atom_type(a.OBAtom) for a in m.atoms]
    assert len(typs) == 16
    ccnt = 0
    ocnt = 0
    hcnt = 0
    for t,r in typs:
        if names[t] == 'Carbon':
            ccnt += 1
            assert r == approx(.76)
        if names[t] == 'Oxygen':
            ocnt += 1
            assert r == approx(.66)
        if names[t] == 'Hydrogen':
            hcnt += 1
            assert r == approx(.31)

    assert ccnt == 7
    assert ocnt == 1
    assert hcnt == 8

def test_subset_elementtyping():
    m = pybel.readstring('smi','c1c(Cl)cccc1CO')
    m.addh()
    subset = [1,6,7,8]
    elemt = molgrid.ElementIndexTyper()
    #old names are required for mapper to have nice mapped names
    mapper = molgrid.SubsetAtomMapper(subset, old_names=elemt.get_type_names())
    t = molgrid.SubsettedElementTyper(mapper, elemt)
    assert t.num_types() == 5
    names = list(t.get_type_names())
    assert names[4] == 'GenericAtom'
    typs = [t.get_atom_type(a.OBAtom) for a in m.atoms]
    assert len(typs) == 16
    ccnt = 0
    ocnt = 0
    hcnt = 0
    other = 0
    for t,r in typs:
        if names[t] == 'Carbon':
            ccnt += 1
            assert r == approx(.76)
        if names[t] == 'Oxygen':
            ocnt += 1
            assert r == approx(.66)
        if names[t] == 'Hydrogen':
            hcnt += 1
            assert r == approx(.31)
        if names[t] == 'GenericAtom':
            other += 1

    assert ccnt == 7
    assert ocnt == 1
    assert hcnt == 7
    assert other == 1
    
    #now let's try a surjective mapping without a catchall type
    subset = [6,[7,8]]
    mapper = molgrid.SubsetAtomMapper(subset, False, old_names=elemt.get_type_names())
    t = molgrid.SubsettedElementTyper(mapper, elemt)

    assert t.num_types() == 2
    names = list(t.get_type_names())
    assert names[1] == 'Nitrogen_Oxygen'
    typs = [t.get_atom_type(a.OBAtom) for a in m.atoms]
    assert len(typs) == 16
    ccnt = 0
    nocnt = 0
    neg = 0
    for t,r in typs:
        if t < 0:
            neg += 1
        elif names[t] == 'Carbon':
            ccnt += 1
            assert r == approx(.76)
        elif names[t] == 'Nitrogen_Oxygen':
            nocnt += 1
            assert r == approx(.66) #aren't any nitrogen

    assert ccnt == 7
    assert nocnt == 1
    assert neg == 8
        
    