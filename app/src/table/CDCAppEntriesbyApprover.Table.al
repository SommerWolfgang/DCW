table 6085738 "CDC App. Entries by Approver"
{
    Caption = 'Approval Entries by Approver';

    fields
    {
        field(1; "Approver ID"; Code[50])
        {
            Caption = 'Approver ID';
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(2; Name; Text[50])
        {
            Caption = 'Name';
        }
        field(3; "No. of Invoices"; Integer)
        {
            BlankZero = true;
            CalcFormula = count("Approval Entry" where("Table ID" = const(38),
                                                        "Document Type" = const(Invoice),
                                                        "Approver ID" = field("Approver ID"),
                                                        Status = const(Open)));
            Caption = 'No. of Invoices';
            Editable = false;
            FieldClass = FlowField;
        }
        field(4; "No. of Credit Memos"; Integer)
        {
            BlankZero = true;
            CalcFormula = count("Approval Entry" where("Table ID" = const(38),
                                                        "Document Type" = const("Credit Memo"),
                                                        "Approver ID" = field("Approver ID"),
                                                        Status = const(Open)));
            Caption = 'No. of Credit Memos';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5; "Due Date Filter"; Date)
        {
            Caption = 'Due Date Filter';
            FieldClass = FlowFilter;
        }
        field(6; "No. of Overdue Apprvl. Entries"; Integer)
        {
            BlankZero = true;
            CalcFormula = count("Approval Entry" where("Table ID" = const(38),
                                                        "Approver ID" = field("Approver ID"),
                                                        "Due Date" = field("Due Date Filter"),
                                                        Status = const(Open)));
            Caption = 'No. of Overdue Approval Entries';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Approver ID")
        {
            Clustered = true;
        }
    }
    procedure DrillDownEntries(DocumentType: Integer; Overdue: Boolean)
    begin
    end;
}