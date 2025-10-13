package com.example.hopital_numerique.services.serviceIntefaces;

import com.example.hopital_numerique.model.Consultation;
import com.example.hopital_numerique.model.Doctor;
import com.example.hopital_numerique.model.Patient;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

public interface ISpatien {

    // En tant que patient, je veux réserver un rendez-vous avec un docteur afin de consulter
    Consultation bookAppointment(Patient patient, Doctor doctor, Consultation consultation);

    // En tant que patient, je veux annuler ou modifier ma réservation
    void cancelAppointment(Patient patient, Consultation consultation);
    Consultation modifyAppointment(Patient patient, Consultation consultation);

    // En tant que patient, je veux consulter l'historique de mes consultations
    List<Consultation> getConsultationHistory(Patient patient);

}
