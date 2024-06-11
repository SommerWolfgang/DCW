table 6086319 "CEM Approval Entry"
{
    Caption = 'EM Approval Entry';

    fields
    {
        field(1; "Table ID"; Integer)
        {
            Caption = 'Table ID';
        }
        field(2; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(4; "Sequence No."; Integer)
        {
            Caption = 'Sequence No.';
        }
        field(7; "Salespers./Purch. Code"; Code[10])
        {
            Caption = 'Salespers./Purch. Code';
        }
        field(8; "Approver ID"; Code[50])
        {
            Caption = 'Approver ID';
            TableRelation = "User Setup";
        }
        field(9; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Created,Open,Cancelled,Rejected,Approved';
            OptionMembers = Created,Open,Canceled,Rejected,Approved;
        }
        field(13; Comment; Boolean)
        {
            CalcFormula = exist("Approval Comment Line" where("Table ID" = field("Table ID"),
                                                               "Document Type" = field("Document Type"),
                                                               "Document No." = field("Document No.")));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(15; Amount; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Amount';

            trigger OnLookup()
            begin
                AmountLookup();
            end;
        }
        field(16; "Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Amount (LCY)';

            trigger OnLookup()
            begin
                AmountLookup();
            end;
        }
        field(17; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(29; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(200; "Continia User ID"; Code[50])
        {
            Caption = 'Continia User ID';
            TableRelation = "CDC Continia User Setup";
        }
        field(201; "Continia User Name"; Text[50])
        {
            CalcFormula = lookup("CDC Continia User".Name where("User ID" = field("Continia User ID")));
            Caption = 'Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(202; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(203; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
        }
        field(204; "Document Date"; Date)
        {
            Caption = 'Document Date';
            NotBlank = true;
        }
        field(205; "Admin Comment"; Text[250])
        {
            Caption = 'Admin Comment';
        }
        field(208; "Global Dimension 1 Code"; Code[20])
        {
            Caption = 'Global Dimension 1 Code';
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(209; "Global Dimension 2 Code"; Code[20])
        {
            Caption = 'Global Dimension 2 Code';
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(210; "Job No."; Code[20])
        {
            Caption = 'Job No.';
            TableRelation = Job;
        }
        field(211; "Job Task No."; Code[20])
        {
            Caption = 'Job Task No.';
            TableRelation = "Job Task"."Job Task No." where("Job No." = field("Job No."));
        }
        field(212; "On Hold"; Code[3])
        {
            Caption = 'On Hold';
        }
        field(213; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = if ("Table ID" = const(6086320)) "CEM Expense Type"
            else
            if ("Table ID" = const(6086338)) "CEM Vehicle"
            else
            if ("Table ID" = const(6086339)) "CEM Expense Header"."No.";
        }
        field(214; Details; Text[250])
        {
            Caption = 'Details';
        }
        field(224; "Approval Entry Type"; Option)
        {
            Caption = 'Approval Entry Type';
            OptionCaption = ' ,Expense,Mileage,Settlement,Per Diem';
            OptionMembers = " ",Expense,Mileage,Settlement,"Per Diem";
        }
        field(6085576; "Temp. Entry Type"; Option)
        {
            Caption = 'Temp. Entry Type';
            OptionCaption = 'Normal,Out of Office Sharing,Normal Sharing';
            OptionMembers = Normal,"Out of Office Sharing","Normal Sharing";
        }
        field(6085577; "Temp. Display Sorting"; Integer)
        {
            Caption = 'Temp. Display Sorting';
        }
        field(6086001; "Pre-approval Amount"; Decimal)
        {
            Caption = 'Pre-approval Amount (LCY)';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
        }
        key(Key2; "Table ID", "Document Type", "Document No.", "Sequence No.")
        {
            Clustered = true;
        }
        key(Key3; "Temp. Entry Type", "Approver ID", "Temp. Display Sorting")
        {
        }
        key(Key4; "Approver ID", Status)
        {
        }
    }

    fieldgroups
    {
    }

    local procedure AmountLookup()
    begin
    end;
}