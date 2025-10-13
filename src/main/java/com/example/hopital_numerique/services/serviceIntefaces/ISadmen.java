package com.example.hopital_numerique.services.serviceIntefaces;

import com.example.hopital_numerique.model.*;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

public interface ISadmen {

    // Department management
    Department createDepartment(Department department);
    void updateDepartment(Department department);
    void deleteDepartment(Department department);
    List<Department> getAllDepartments();
    Department getDepartmentById(Department department);

    // Doctor management
    Doctor createDoctor(Doctor doctor);
    void updateDoctor(Doctor doctor);
    void deleteDoctor(Doctor doctor);
    List<Doctor> getAllDoctors();
    List<Doctor> getDoctorsByDepartment(Doctor doctor);
    Doctor getDoctorById(Doctor doctor);

    // room management
    Room createRoom(Room room);
    void updateRoom(Room room);
    void deleteRoom(Room room);
    void assignRoomToConsultation(Consultation consultation, Room room);
    void isRoomAvailable(Room room, LocalDate date, LocalTime time);
    List<Room> getAllRooms();
    List<Room> getAvailableRooms(Room room);

    // consultations management
    List<Consultation> getAllConsultations();
    List<Consultation> getConsultationsByDate(LocalDate date);
    List<Consultation> getConsultationsByStatus(Status status);
    List<Consultation> getConsultationsByDoctor(Doctor doctor);
    List<Consultation> getConsultationsByPatient(Patient patient);
    List<Consultation> getConsultationsByDepartment(Department department);

    // Statistics
    int getTotalConsultationsCount();
    int getConsultationsCountByStatus(Status status);
    int getConsultationsCountByDoctor(Doctor doctor);
}

