package com.example.hopital_numerique.dao.daoInterfaces;

import com.example.hopital_numerique.model.Patient;
import java.util.List;

public interface Ipatient {
    void save(Patient patient);
    void update(Patient patient);
    void delete(int patientId);
    Patient findById(int patientId);
//    Patient findByEmail(String email);
    List<Patient> findAll();
    List<Patient> findByFirstName(String firstName);
    List<Patient> findByLastName(String lastName);
}
