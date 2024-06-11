table 6086325 "CEM Attendee Inbox"
{
    Caption = 'Attendee Inbox';
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
            Editable = false;
            TableRelation = if ("Table ID" = const(6086323)) "CEM Expense Inbox"
            else
            if ("Table ID" = const(6086353)) "CEM Mileage Inbox";
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
        CheckInbox();
    end;

    trigger OnInsert()
    var
        ExpenseAttendeesInbox: Record "CEM Attendee Inbox";
    begin
        CheckInbox();
        if "Entry No." = 0 then begin
            ExpenseAttendeesInbox.SetRange("Table ID", "Table ID");
            ExpenseAttendeesInbox.SetRange("Doc. Ref. No.", "Doc. Ref. No.");
            if ExpenseAttendeesInbox.FindLast() then
                "Entry No." := ExpenseAttendeesInbox."Entry No." + 1
            else
                "Entry No." := 1;
        end;
    end;

    trigger OnModify()
    begin
        CheckInbox();
    end;

    trigger OnRename()
    begin
        CheckInbox();
    end;

    var
        MultipleEmployees: Label '%1 Employees';
        MultipleGuests: Label '%1 Guests';
        SingleEmployee: Label '%1 Employee';
        SingleGuest: Label '%1 Guest';

    local procedure CheckInbox()
    var
        ExpAllocationInbox: Record "CEM Expense Allocation Inbox";
        ExpenseInbox: Record "CEM Expense Inbox";
        MileageInbox: Record "CEM Mileage Inbox";
    begin
        case "Table ID" of
            DATABASE::"CEM Expense Inbox":
                begin
                    ExpenseInbox.Get("Doc. Ref. No.");
                    if ExpenseInbox.Status = ExpenseInbox.Status::Accepted then
                        ExpenseInbox.TestField(Status, ExpenseInbox.Status::Error);
                end;
            DATABASE::"CEM Mileage Inbox":
                begin
                    MileageInbox.Get("Doc. Ref. No.");
                    if MileageInbox.Status = MileageInbox.Status::Accepted then
                        MileageInbox.TestField(Status, MileageInbox.Status::Error);
                end;
            DATABASE::"CEM Expense Allocation Inbox":
                begin
                    ExpAllocationInbox.Get("Doc. Ref. No.");
                    ExpenseInbox.Get(ExpAllocationInbox."Inbox Entry No.");
                    if ExpenseInbox.Status = ExpenseInbox.Status::Accepted then
                        ExpenseInbox.TestField(Status, ExpenseInbox.Status::Error);
                end;
        end;
    end;


    procedure GetAttendeesForDisplay(TableID: Integer; DocRefNo: Integer) DisplayTxt: Text[150]
    var
        ExpAttendeeInbox: Record "CEM Attendee Inbox";
        NoOfEmployees: Integer;
        NoOfGuests: Integer;
    begin
        ExpAttendeeInbox.SetRange("Table ID", TableID);
        ExpAttendeeInbox.SetRange("Doc. Ref. No.", DocRefNo);
        case ExpAttendeeInbox.Count of
            0:
                exit;

            1:
                begin
                    ExpAttendeeInbox.FindFirst();
                    if ExpAttendeeInbox.Name <> '' then
                        exit(StrSubstNo('%1 (%2)', ExpAttendeeInbox.Name, ExpAttendeeInbox.Type))
                    else
                        exit(StrSubstNo('%1 (%2)', ExpAttendeeInbox."Company Name", ExpAttendeeInbox.Type));
                end;

            else begin
                ExpAttendeeInbox.SetRange(Type, ExpAttendeeInbox.Type::Employee);
                NoOfEmployees := ExpAttendeeInbox.Count;
                ExpAttendeeInbox.SetRange(Type, ExpAttendeeInbox.Type::Guest);
                NoOfGuests := ExpAttendeeInbox.Count;

                if NoOfEmployees = 1 then
                    DisplayTxt := StrSubstNo(SingleEmployee, NoOfEmployees)
                else
                    DisplayTxt := StrSubstNo(MultipleEmployees, NoOfEmployees);

                if (NoOfEmployees > 0) and (NoOfGuests > 0) then
                    DisplayTxt := DisplayTxt + ', ';

                if NoOfGuests > 1 then
                    DisplayTxt := DisplayTxt + StrSubstNo(MultipleGuests, NoOfGuests)
                else
                    if NoOfGuests = 1 then
                        DisplayTxt := DisplayTxt + StrSubstNo(SingleGuest, NoOfGuests)
            end;
        end;
    end;
}

