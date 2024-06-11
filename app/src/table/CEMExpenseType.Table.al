table 6086307 "CEM Expense Type"
{
    Caption = 'Expense Type';
    DataCaptionFields = "Code", Description;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; Description; Text[30])
        {
            Caption = 'Description';

            trigger OnValidate()
            begin
                if ("Search Name" = UpperCase(xRec.Description)) or ("Search Name" = '') then
                    "Search Name" := Description;
            end;
        }
        field(4; "Search Name"; Code[30])
        {
            Caption = 'Search Name';
        }
        field(6; "Hide from Expense User"; Boolean)
        {
            Caption = 'Hide from Expense User';
        }
        field(7; "Exclude Transactions"; Boolean)
        {
            Caption = 'Exclude Transactions';
        }
        field(8; Image; Text[30])
        {
            Caption = 'Image';
            TableRelation = "CEM Image".Description;
        }
        field(10; "No Refund"; Boolean)
        {
            Caption = 'No Refund';
        }
        field(11; Attachment; Option)
        {
            Caption = 'Attachment';
            OptionCaption = 'Recommended,Mandatory,Optional';
            OptionMembers = Recommended,Mandatory,Optional;
        }
        field(30; "Global Dimension 1 Code"; Code[20])
        {
            Caption = 'Global Dimension 1 Code';
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Global Dimension 1 Code");
            end;
        }
        field(31; "Global Dimension 2 Code"; Code[20])
        {
            Caption = 'Global Dimension 2 Code';
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Global Dimension 2 Code");
            end;
        }
        field(32; "Attendees Required"; Boolean)
        {
            Caption = 'Attendees Required';
        }
        field(33; "No. of Company Policies"; Integer)
        {
            CalcFormula = Count("CEM Company Policy" WHERE("Document Type" = CONST(Expense),
                                                            "Document Account No." = FIELD(Code)));
            Caption = 'No. of Company Policies';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        EMDefDim: Record "CEM Default Dimension";
        ExpPostingSetup: Record "CEM Posting Setup";
    begin
        ExpPostingSetup.SetRange(Type, ExpPostingSetup.Type::Expense);
        ExpPostingSetup.SetRange("No.", Code);
        ExpPostingSetup.DeleteAll(true);

        EMDefDim.SetRange("Table ID", DATABASE::"CEM Expense Type");
        EMDefDim.SetRange("No.", Code);
        EMDefDim.DeleteAll;
    end;

    local procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    var
        EMDimMgt: Codeunit "CEM Dimension Mgt.";
    begin
        EMDimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode);
        EMDimMgt.SaveDefaultDim(DATABASE::"CEM Expense Type", Code, FieldNumber, ShortcutDimCode);
        Modify;
    end;


    procedure IsRefundable() IsRefundable: Boolean
    begin
        exit(not "No Refund");
    end;


    procedure GetNonRefundableExpType(): Code[20]
    var
        ExpType: Record "CEM Expense Type";
    begin
        ExpType.SetRange("No Refund", true);
        if ExpType.FindFirst then
            exit(ExpType.Code);
    end;
}

