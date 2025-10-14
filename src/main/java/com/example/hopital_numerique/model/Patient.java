package com.example.hopital_numerique.model;

import jakarta.persistence.*;

import java.util.List;

@Entity
@Table(name = "patients")
@PrimaryKeyJoinColumn(name = "person_id")
public class Patient extends Person {

    private float weight;
    private float height;

    @OneToMany(mappedBy = "patient", cascade = CascadeType.ALL, fetch = FetchType.EAGER)
    private List<Consultation> consultations;

    public Patient(String firstName, String lastName, String email, String password, String role, float weight, float height, List<Consultation> consultations) {
        super(firstName, lastName, email, password, role);
        this.weight = weight;
        this.height = height;
        this.consultations = consultations;
    }

    public Patient(float weight, float height, List<Consultation> consultations) {
        this.weight = weight;
        this.height = height;
        this.consultations = consultations;
    }

    public Patient() {
    }

    public float getWeight() {
        return weight;
    }

    public void setWeight(float weight) {
        this.weight = weight;
    }

    public float getHeight() {
        return height;
    }

    public void setHeight(float height) {
        this.height = height;
    }

    public List<Consultation> getConsultations() {
        return consultations;
    }

    public void setConsultations(List<Consultation> consultations) {
        this.consultations = consultations;
    }

    @Override
    public String toString() {
        return "Patient{" +
                "weight=" + weight +
                ", height=" + height +
                ", consultations=" + consultations +
                '}';
    }
}