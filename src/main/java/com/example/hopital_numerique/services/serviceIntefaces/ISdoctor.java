package com.example.hopital_numerique.services.serviceIntefaces;

import com.example.hopital_numerique.model.Consultation;
import com.example.hopital_numerique.model.Doctor;
import com.example.hopital_numerique.model.Status;
import java.time.LocalDate;
import java.util.List;

public interface ISdoctor {

    // docteur planning
    List<Consultation> getDoctorConsultations(Doctor doctor);

    // valider or refuser Consultation
    void validateConsultation(Consultation consultation, Doctor doctor);
    void refuseConsultation(Consultation consultation, Doctor doctor);

    // saisir le consultation
    void addConsultationReport(Consultation consultation, Doctor doctor);
    void updateConsultationReport(Consultation consultation, Doctor doctor);

    // useful functionality
    void updateConsultationStatus(Consultation consultation, Doctor doctor);
    List<Consultation> getPendingAppointments(Doctor doctor);
    List<Consultation> getConsultationsByStatus(Consultation consultation, Doctor doctor);
}
