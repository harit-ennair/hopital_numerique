package com.example.hopital_numerique.model;

import jakarta.persistence.*;

import java.time.LocalDate;
import java.time.LocalTime;

@Entity
@Table(name = "consultations")
public class Consultation {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    private LocalDate date;
    private LocalTime hour;
    @Enumerated(EnumType.STRING)
    @Column(name = "status_name")
    private Status statusByName;

    private String report;
    @ManyToOne
    @JoinColumn(name = "patient_id")
    private Patient patient;
    @ManyToOne
    @JoinColumn(name = "doctor_id")
    private Doctor doctor;
    @ManyToOne
    @JoinColumn(name = "room_id")
    private Room room;

    public Consultation(int id, LocalDate date, LocalTime hour, Status statusByName, String report, Patient patient, Doctor doctor, Room room) {
        this.id = id;
        this.date = date;
        this.hour = hour;
        this.statusByName = statusByName;
        this.report = report;
        this.patient = patient;
        this.doctor = doctor;
        this.room = room;
    }

    public Consultation() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public LocalDate getDate() {
        return date;
    }

    public void setDate(LocalDate date) {
        this.date = date;
    }

    public LocalTime getHour() {
        return hour;
    }

    public void setHour(LocalTime hour) {
        this.hour = hour;
    }

    public Status getStatusByName() {
        return statusByName;
    }

    public void setStatusByName(Status statusByName) {
        this.statusByName = statusByName;
    }

    public String getReport() {
        return report;
    }

    public void setReport(String report) {
        this.report = report;
    }

    public Patient getPatient() {
        return patient;
    }

    public void setPatient(Patient patient) {
        this.patient = patient;
    }

    public Doctor getDoctor() {
        return doctor;
    }

    public void setDoctor(Doctor doctor) {
        this.doctor = doctor;
    }

    public Room getRoom() {
        return room;
    }

    public void setRoom(Room room) {
        this.room = room;
    }

    @Override
    public String toString() {
        return "Consultation{" +
                "id=" + id +
                ", date=" + date +
                ", hour=" + hour +
                ", statusByName=" + statusByName +
                ", report='" + report + '\'' +
                ", patient=" + patient +
                ", doctor=" + doctor +
                ", room=" + room +
                '}';
    }
}