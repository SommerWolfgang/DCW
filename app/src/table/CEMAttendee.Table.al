table 6086308 "CEM Attendee"
{
    Caption = 'Attendee';
    DataCaptionFields = Name, "Company Name";

    fields
    {
        field(1; "Table ID"; Integer)
        {
            Caption = 'Table ID';
        }
        field(2; "Doc. Ref. No."; Integer)
        {
            Caption = 'Doc. Ref. No.';
            TableRelation = IF ("Table ID" = CONST(6086320)) "CEM Expense"
            ELSE
            IF ("Table ID" = CONST(6086338)) "CEM Mileage";
        }
        field(3; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(10; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Employee,Guest';
            OptionMembers = Employee,Guest;
        }
        field(20; Name; Text[50])
        {
            Caption = 'Name';
            NotBlank = true;
        }
        field(30; "Company Name"; Text[50])
        {
            Caption = 'Company Name';
        }
    }

    keys
    {
        key(Key1; "Table ID", "Doc. Ref. No.", "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        TestNotPosted;
    end;

    trigger OnInsert()
    begin
        TestField(Name);
        TestNotPosted;

        if "Entry No." = 0 then
            "Entry No." := GetNextEntryNo;
    end;

    trigger OnModify()
    begin
        TestNotPosted;
    end;

    trigger OnRename()
    begin
        TestNotPosted;
    end;

    var
        MultipleEmployees: Label '%1 Employees';
        MultipleGuests: Label '%1 Guests';
        SingleEmployee: Label '%1 Employee';
        SingleGuest: Label '%1 Guest';

    local procedure TestNotPosted()
    var
        Expense: Record "CEM Expense";
        ExpAllocation: Record "CEM Expense Allocation";
        Mileage: Record "CEM Mileage";
    begin
        case "Table ID" of
            DATABASE::"CEM Expense":
                begin
                    Expense.Get("Doc. Ref. No.");
                    Expense.TestField(Posted, false);
                    Expense.TestStatusOrUserAllowsChange;
                end;
            DATABASE::"CEM Mileage":
                begin
                    Mileage.Get("Doc. Ref. No.");
                    Mileage.TestField(Posted, false);
                    Mileage.TestStatusOrUserAllowsChange;
                end;
            DATABASE::"CEM Expense Allocation":
                begin
                    ExpAllocation.Get("Doc. Ref. No.");
                    Expense.Get(ExpAllocation."Expense Entry No.");
                    Expense.TestField(Posted, false);
                    Expense.TestStatusOrUserAllowsChange;
                end;
        end;
    end;


    procedure GetNextEntryNo(): Integer
    var
        ExpenseAttendee: Record "CEM Attendee";
    begin
        ExpenseAttendee.SetRange("Table ID", "Table ID");
        ExpenseAttendee.SetRange("Doc. Ref. No.", "Doc. Ref. No.");
        if ExpenseAttendee.FindLast then
            exit(ExpenseAttendee."Entry No." + 1)
        else
            exit(1);
    end;


    procedure AttendeesUpdated(var EMAttendee: Record "CEM Attendee"; DocRefNo: Integer; TableNo: Integer): Boolean
    var
        xEMAttendee: Record "CEM Attendee";
    begin
        EMAttendee.SetRange("Table ID", TableNo);
        EMAttendee.SetRange("Doc. Ref. No.", DocRefNo);

        xEMAttendee.SetRange("Table ID", TableNo);
        xEMAttendee.SetRange("Doc. Ref. No.", DocRefNo);

        if EMAttendee.FindSet then
            repeat
                if not xEMAttendee.Get(TableNo, EMAttendee."Doc. Ref. No.", EMAttendee."Entry No.") then
                    exit(true);

                if (EMAttendee.Type <> xEMAttendee.Type) or
                   (EMAttendee.Name <> xEMAttendee.Name) or
                   (EMAttendee."Company Name" <> xEMAttendee."Company Name")
                then
                    exit(true);
            until EMAttendee.Next = 0;

        if xEMAttendee.FindSet then
            repeat
                if not EMAttendee.Get(TableNo, xEMAttendee."Doc. Ref. No.", xEMAttendee."Entry No.") then
                    exit(true);
            until xEMAttendee.Next = 0;
    end;


    procedure GetAttendeesForDisplay(TableID: Integer; DocRefNo: Integer) DisplayTxt: Text[150]
    var
        ExpAttendee: Record "CEM Attendee";
        NoOfEmployees: Integer;
        NoOfGuests: Integer;
    begin
        ExpAttendee.SetRange("Table ID", TableID);
        ExpAttendee.SetRange("Doc. Ref. No.", DocRefNo);
        case ExpAttendee.Count of
            0:
                exit;

            1:
                begin
                    ExpAttendee.FindFirst;
                    if ExpAttendee.Name <> '' then
                        exit(StrSubstNo('%1 (%2)', ExpAttendee.Name, ExpAttendee.Type))
                    else
                        exit(StrSubstNo('%1 (%2)', ExpAttendee."Company Name", ExpAttendee.Type));
                end;

            else begin
                ExpAttendee.SetRange(Type, ExpAttendee.Type::Employee);
                NoOfEmployees := ExpAttendee.Count;
                ExpAttendee.SetRange(Type, ExpAttendee.Type::Guest);
                NoOfGuests := ExpAttendee.Count;

                if NoOfEmployees > 1 then
                    DisplayTxt := StrSubstNo(MultipleEmployees, NoOfEmployees)
                else
                    if NoOfEmployees = 1 then
                        DisplayTxt := StrSubstNo(SingleEmployee, NoOfEmployees);

                if (NoOfEmployees > 0) and (NoOfGuests > 0) then
                    DisplayTxt := DisplayTxt + ', ';

                if NoOfGuests > 1 then
                    DisplayTxt := DisplayTxt + StrSubstNo(MultipleGuests, NoOfGuests)
                else
                    if NoOfGuests = 1 then
                        DisplayTxt := DisplayTxt + StrSubstNo(SingleGuest, NoOfGuests);

            end;
        end;
    end;
}

