//
// ********************************************************************
// * License and Disclaimer                                           *
// *                                                                  *
// * The  Geant4 software  is  copyright of the Copyright Holders  of *
// * the Geant4 Collaboration.  It is provided  under  the terms  and *
// * conditions of the Geant4 Software License,  included in the file *
// * LICENSE and available at  http://cern.ch/geant4/license .  These *
// * include a list of copyright holders.                             *
// *                                                                  *
// * Neither the authors of this software system, nor their employing *
// * institutes,nor the agencies providing financial support for this *
// * work  make  any representation or  warranty, express or implied, *
// * regarding  this  software system or assume any liability for its *
// * use.  Please see the license in the file  LICENSE  and URL above *
// * for the full disclaimer and the limitation of liability.         *
// *                                                                  *
// * This  code  implementation is the result of  the  scientific and *
// * technical work of the GEANT4 collaboration.                      *
// * By using,  copying,  modifying or  distributing the software (or *
// * any work based  on the software)  you  agree  to acknowledge its *
// * use  in  resulting  scientific  publications,  and indicate your *
// * acceptance of all terms of the Geant4 Software license.          *
// ********************************************************************
//
// $Id: G4F21GEMProbability.hh 67983 2013-03-13 10:42:03Z gcosmo $
//
// Hadronic Process: Nuclear De-excitations
// by V. Lara (Nov 1999) 
//

#ifndef G4F21GEMProbability_h
#define G4F21GEMProbability_h 1


#include "G4GEMProbability.hh"


class G4F21GEMProbability : public G4GEMProbability
{
public:
  // Only available constructor
  G4F21GEMProbability();
    
  ~G4F21GEMProbability();

private:  
  // Copy constructor
  G4F21GEMProbability(const G4F21GEMProbability &right);
    
  const G4F21GEMProbability & operator=(const G4F21GEMProbability &right);
  G4bool operator==(const G4F21GEMProbability &right) const;
  G4bool operator!=(const G4F21GEMProbability &right) const;
  
};


#endif
