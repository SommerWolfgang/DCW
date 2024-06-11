table 6086364 "CEM Reminder"
{
    Caption = 'EM Reminder';
    Permissions = TableData "CDC Continia User Setup" = r;

    fields
    {
        field(1; "Table ID"; Integer)
        {
            Caption = 'Table ID';
        }
        field(2; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Budget,Settlement';
            OptionMembers = Budget,Settlement;
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(4; "Doc. Ref. No."; Integer)
        {
            Caption = 'Doc. Ref. No.';
        }
        field(10; "Reminder Terms Code"; Code[10])
        {
            Caption = 'Reminder Terms Code';
            NotBlank = true;
            TableRelation = "CEM Reminder Terms";
        }
        field(11; "No."; Integer)
        {
            Caption = 'No.';
            MinValue = 1;
            NotBlank = true;
        }
        field(12; "Reminder Sent"; Date)
        {
            Caption = 'Reminder Sent';
        }
    }

    keys
    {
        key(Key1; "Table ID", "Document Type", "Document No.", "Doc. Ref. No.", "Reminder Terms Code", "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }


    procedure CreateReminder(TableID: Integer; DocumentType: Integer; DocumentNo: Code[20]; DocRefNo: Integer; ContiniaUserID: Code[50])
    var
        ContiniaUserSetup: Record "CDC Continia User Setup";
        EMReminder: Record "CEM Reminder";
        ReminderLevel: Record "CEM Reminder Level";
    begin
        if not ContiniaUserSetup.Get(ContiniaUserID) then
            exit;

        EMReminder.SetCurrentKey("Table ID", "Document Type", "Document No.", "Doc. Ref. No.");
        EMReminder.SetRange("Table ID", TableID);
        EMReminder.SetRange("Document Type", DocumentType);
        EMReminder.SetRange("Document No.", DocumentNo);
        EMReminder.SetRange("Doc. Ref. No.", DocRefNo);
        EMReminder.SetRange("Reminder Terms Code", ContiniaUserSetup."Expense Reminder Code");
        if EMReminder.FindLast() then;

        "Table ID" := TableID;
        "Document Type" := DocumentType;
        "Document No." := DocumentNo;
        "Doc. Ref. No." := DocRefNo;
        "Reminder Terms Code" := ContiniaUserSetup."Expense Reminder Code";
        "No." := EMReminder."No." + 1;
        "Reminder Sent" := Today;
        Insert();

        ReminderLevel.SetRange("Reminder Terms Code", ContiniaUserSetup."Expense Reminder Code");
        ReminderLevel.SetRange("No.", "No.");
        if not ReminderLevel.FindLast() then begin
            ReminderLevel.SetRange("No.");
            if not ReminderLevel.FindLast() then;
        end;
    end;


    procedure ResetReminder(TableID: Integer; DocumentType: Integer; DocumentNo: Code[20]; DocRefNo: Integer; ContiniaUserID: Code[50])
    var
        ContiniaUserSetup: Record "CDC Continia User Setup";
    begin
        if not ContiniaUserSetup.Get(ContiniaUserID) then
            exit;

        SetRange("Table ID", TableID);
        SetRange("Document Type", DocumentType);
        SetRange("Document No.", DocumentNo);
        SetRange("Doc. Ref. No.", DocRefNo);
        SetRange("Reminder Terms Code", ContiniaUserSetup."Expense Reminder Code");
        if FindLast() then begin
            "Reminder Sent" := Today;
            Modify(true);
        end;
    end;


    procedure NextReminderDate(ContiniaUserID: Code[50]; TableID: Integer; DocumentType: Integer; DocumentNo: Code[20]; DocRefNo: Integer; DateCreated: Date): Date
    var
        ContiniaUserSetup: Record "CDC Continia User Setup";
        EMReminder: Record "CEM Reminder";
        ReminderLevel: Record "CEM Reminder Level";
        ReminderCode: Record "CEM Reminder Terms";
    begin
        if not ContiniaUserSetup.Get(ContiniaUserID) then
            exit(0D);

        if ContiniaUserSetup."Expense Reminder Code" = '' then
            exit(0D);

        if not ReminderCode.Get(ContiniaUserSetup."Expense Reminder Code") then
            exit(0D);

        if DateCreated = 0D then
            exit(Today);

        EMReminder.SetRange("Table ID", TableID);
        EMReminder.SetRange("Document Type", DocumentType);
        EMReminder.SetRange("Document No.", DocumentNo);
        EMReminder.SetRange("Doc. Ref. No.", DocRefNo);
        EMReminder.SetRange("Reminder Terms Code", ReminderCode.Code);
        if not EMReminder.FindLast() then begin
            EMReminder."Reminder Terms Code" := ReminderCode.Code;
            EMReminder."Reminder Sent" := DateCreated;
        end;

        if ReminderLevel.Get(EMReminder."Reminder Terms Code", EMReminder."No." + 1) then
            exit(CalcDate(ReminderLevel."Grace Period", EMReminder."Reminder Sent"))
        else begin
            ReminderLevel.SetRange("Reminder Terms Code", ContiniaUserSetup."Expense Reminder Code");
            if ReminderLevel.FindLast() then
                exit(CalcDate(ReminderLevel."Grace Period", EMReminder."Reminder Sent"));
        end;
    end;
}

