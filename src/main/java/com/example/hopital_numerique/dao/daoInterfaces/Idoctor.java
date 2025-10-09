package com.example.hopital_numerique.dao.daoInterfaces;

import com.example.hopital_numerique.model.Doctor;
import com.example.hopital_numerique.model.Department;
import java.util.List;

public interface Idoctor {
    void save(Doctor doctor);
    void update(Doctor doctor);
    void delete(int doctorId);
    Doctor findById(int doctorId);
    Doctor findByEmail(String email);
    List<Doctor> findAll();
    List<Doctor> findBySpecialty(String specialty);
    List<Doctor> findByDepartment(Department department);
    List<Doctor> findByFirstName(String firstName);
    List<Doctor> findByLastName(String lastName);
}
