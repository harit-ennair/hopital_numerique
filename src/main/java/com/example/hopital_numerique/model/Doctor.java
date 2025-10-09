package com.example.hopital_numerique.model;

import jakarta.persistence.*;

import java.util.List;

@Entity
@Table(name = "doctors")
@PrimaryKeyJoinColumn(name = "person_id")
public class Doctor extends Person {
    private String specialty;

    @ManyToOne
    @JoinColumn(name = "department_id")
    private Department department;

    @OneToMany(mappedBy = "doctor", cascade = CascadeType.ALL)
    private List<Consultation> consultations;

    public Doctor(String firstName, String lastName, String email, String password, String role, String specialty, Department department, List<Consultation> consultations) {
        super(firstName, lastName, email, password, role);
        this.specialty = specialty;
        this.department = department;
        this.consultations = consultations;
    }

    public Doctor(String specialty, Department department, List<Consultation> consultations) {
        this.specialty = specialty;
        this.department = department;
        this.consultations = consultations;
    }

    public Doctor() {
    }

    public String getSpecialty() {
        return specialty;
    }

    public void setSpecialty(String specialty) {
        this.specialty = specialty;
    }

    public Department getDepartment() {
        return department;
    }

    public void setDepartment(Department department) {
        this.department = department;
    }

    public List<Consultation> getConsultations() {
        return consultations;
    }

    public void setConsultations(List<Consultation> consultations) {
        this.consultations = consultations;
    }

    @Override
    public String toString() {
        return "Doctor{" +
                "specialty='" + specialty + '\'' +
                ", department=" + department +
                ", consultations=" + consultations +
                '}';
    }
}