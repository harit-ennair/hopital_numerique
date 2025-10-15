package com.example.hopital_numerique.services.serviceIntefaces;

import com.example.hopital_numerique.model.Consultation;
import com.example.hopital_numerique.model.Doctor;
import com.example.hopital_numerique.model.Patient;
import com.example.hopital_numerique.model.Room;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

public interface ISpatien {


    //    boolean isRoomAvailable(Room room, LocalDate date, LocalTime time);
    boolean isRoomAvailable(Consultation consultation);
    boolean isDoctorAvailable(Consultation consultation);
    boolean isAvailable(Consultation consultation, List<Consultation> consultations);


    // En tant que patient, je veux réserver un rendez-vous avec un docteur afin de consulter
    Patient addPatient(Patient patient);
    Consultation bookAppointment(Patient patient, Doctor doctor, Consultation consultation , Room room , LocalDate date, LocalTime hour);

    // En tant que patient, je veux annuler ou modifier ma réservation
    void cancelAppointment(Patient patient, Consultation consultation);
    Consultation modifyAppointment(Patient patient, Consultation consultation, Room room , LocalDate date, LocalTime hour);

    // En tant que patient, je veux consulter l'historique de mes consultations
    List<Consultation> getConsultationHistory(Patient patient);

}
