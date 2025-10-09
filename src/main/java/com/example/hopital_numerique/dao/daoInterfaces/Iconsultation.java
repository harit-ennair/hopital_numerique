package com.example.hopital_numerique.dao.daoInterfaces;

import com.example.hopital_numerique.model.Consultation;
import com.example.hopital_numerique.model.Patient;
import com.example.hopital_numerique.model.Doctor;
import com.example.hopital_numerique.model.Room;
import com.example.hopital_numerique.model.Status;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

public interface Iconsultation {
    void save(Consultation consultation);
    void update(Consultation consultation);
    void delete(int consultationId);
    Consultation findById(int consultationId);
    List<Consultation> findAll();
    List<Consultation> findByPatient(Patient patient);
    List<Consultation> findByDoctor(Doctor doctor);
    List<Consultation> findByRoom(Room room);
    List<Consultation> findByDate(LocalDate date);
    List<Consultation> findByStatus(Status status);
    List<Consultation> findByPatientId(int patientId);
    List<Consultation> findByDoctorId(int doctorId);
    List<Consultation> findByDateRange(LocalDate startDate, LocalDate endDate);
    List<Consultation> findByDoctorAndDate(Doctor doctor, LocalDate date);
    boolean isRoomAvailable(Room room, LocalDate date, LocalTime time);
    boolean isDoctorAvailable(Doctor doctor, LocalDate date, LocalTime time);
}
