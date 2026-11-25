trigger LeadTrigger on Lead (before insert, after insert) {
    if (Trigger.isBefore && Trigger.isInsert) {
        LeadQualificationHandler.qualifyLeads(Trigger.new);
    }

    if (Trigger.isAfter && Trigger.isInsert) {
        LeadQualificationHandler.createFollowUpTasks(Trigger.new);
    }
}
