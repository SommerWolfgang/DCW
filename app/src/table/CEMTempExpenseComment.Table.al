table 6086356 "CEM Temp. Expense Comment"
{
    Caption = 'Expense Management Comment';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            TableRelation = "CEM Expense";
        }
        field(2; Importance; Option)
        {
            Caption = 'Importance';
            OptionCaption = 'Error,Warning,Information';
            OptionMembers = Error,Warning,Information;
        }
        field(3; "Area"; Code[20])
        {
            Caption = 'Code';
        }
        field(4; Comment; Text[250])
        {
            Caption = 'Comment';
        }
        field(5; Source; Option)
        {
            Caption = 'Source';
            Editable = false;
            OptionCaption = ' ,Expense Comment,Approval Comment,Mileage Comment,Settlement Comment,Per Diem Comment';
            OptionMembers = " ",ExpenseComment,ApprovalComment,MileageComment,SettlementComment,PerDiemComment;
        }
        field(6; "Doc. Ref. No."; Integer)
        {
            Caption = 'Document Reference No.';
        }
        field(7; "Created Date/Time"; DateTime)
        {
            Caption = 'Created Date Time';
            Editable = false;
        }
        field(8; "Created by"; Code[50])
        {
            Caption = 'Created by';
            Editable = false;
            TableRelation = "CDC Continia User Setup";
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(9; "Table ID"; Integer)
        {
            Caption = 'Table ID';
        }
        field(10; "Doc. Ref. No. (Code)"; Code[20])
        {
            Caption = 'Document Reference No. (Code)';
        }
        field(11; "App. Cmt. Entry No."; Integer)
        {
            Caption = 'Approval Comment Entry No.';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; Importance)
        {
        }
    }

    fieldgroups
    {
    }
}

