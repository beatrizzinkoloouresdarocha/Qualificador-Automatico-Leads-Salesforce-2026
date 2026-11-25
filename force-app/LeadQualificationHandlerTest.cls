@IsTest
private class LeadQualificationHandlerTest {

    @IsTest
    static void testHotLeadQualificationAndTaskCreation() {
        Lead hotLead = new Lead(
            FirstName = 'Carlos',
            LastName = 'Mendes',
            Company = 'Tech Sul LTDA',
            Email = 'carlos@techsul.com',
            Phone = '41999990000',
            AnnualRevenue = 250000,
            Urgencia__c = 'Alta'
        );

        Test.startTest();
        insert hotLead;
        Test.stopTest();

        Lead insertedLead = [
            SELECT Rating, Pontuacao_Lead__c
            FROM Lead
            WHERE Id = :hotLead.Id
        ];

        System.assertEquals(100, insertedLead.Pontuacao_Lead__c, 'Pontuação esperada deve ser 100.');
        System.assertEquals('Hot', insertedLead.Rating, 'Rating esperado deve ser Hot.');

        List<Task> tasks = [
            SELECT Subject, Priority, ActivityDate
            FROM Task
            WHERE WhoId = :hotLead.Id
        ];

        System.assertEquals(1, tasks.size(), 'Deve criar 1 tarefa de follow-up para Lead Hot.');
        System.assertEquals('High', tasks[0].Priority, 'Prioridade da tarefa deve ser High.');
        System.assertEquals(Date.today().addDays(1), tasks[0].ActivityDate, 'Vencimento deve ser D+1.');
    }

    @IsTest
    static void testColdLeadDoesNotCreateTask() {
        Lead coldLead = new Lead(
            FirstName = 'Ana',
            LastName = 'Souza',
            Company = 'Loja Exemplo',
            Urgencia__c = 'Baixa'
        );

        Test.startTest();
        insert coldLead;
        Test.stopTest();

        Lead insertedLead = [
            SELECT Rating, Pontuacao_Lead__c
            FROM Lead
            WHERE Id = :coldLead.Id
        ];

        System.assertEquals(0, insertedLead.Pontuacao_Lead__c, 'Pontuação esperada deve ser 0.');
        System.assertEquals('Cold', insertedLead.Rating, 'Rating esperado deve ser Cold.');

        List<Task> tasks = [SELECT Id FROM Task WHERE WhoId = :coldLead.Id];
        System.assertEquals(0, tasks.size(), 'Não deve criar tarefa para Lead Cold.');
    }
}
