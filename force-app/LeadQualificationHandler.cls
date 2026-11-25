public with sharing class LeadQualificationHandler {

    public static void qualifyLeads(List<Lead> newLeads) {
        for (Lead ld : newLeads) {
            Integer score = 0;

            if (ld.AnnualRevenue != null && ld.AnnualRevenue >= 100000) {
                score += 50;
            } else if (ld.AnnualRevenue != null && ld.AnnualRevenue > 0) {
                score += 20;
            }

            if (ld.Urgencia__c == 'Alta') {
                score += 40;
            } else if (ld.Urgencia__c == 'Média') {
                score += 20;
            }

            if (String.isNotBlank(ld.Email) && String.isNotBlank(ld.Phone)) {
                score += 10;
            }

            ld.Pontuacao_Lead__c = score;

            if (score >= 70) {
                ld.Rating = 'Hot';
            } else if (score >= 40) {
                ld.Rating = 'Warm';
            } else {
                ld.Rating = 'Cold';
            }
        }
    }

    public static void createFollowUpTasks(List<Lead> insertedLeads) {
        List<Task> tasksToInsert = new List<Task>();

        for (Lead ld : insertedLeads) {
            if (ld.Rating == 'Hot') {
                Task followUp = new Task(
                    WhoId = ld.Id,
                    OwnerId = ld.OwnerId,
                    Subject = 'Follow-up Prioritário: Entrar em contato com Lead Hot',
                    Priority = 'High',
                    Status = 'Not Started',
                    ActivityDate = Date.today().addDays(1),
                    Description = 'Lead qualificado automaticamente com pontuação ' + ld.Pontuacao_Lead__c + '.'
                );
                tasksToInsert.add(followUp);
            }
        }

        if (!tasksToInsert.isEmpty()) {
            insert tasksToInsert;
        }
    }
}
