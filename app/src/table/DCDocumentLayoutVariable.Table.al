table 12032006 "DC - Document Layout Variable"
{
    Caption = 'Document Layout Variable';

    fields
    {
        field(1; "Layout No."; Code[10])
        {
            Caption = 'Layout No.';
        }
        field(2; "Layout Line No."; Integer)
        {
            Caption = 'Layout Line No.';
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Value,Caption,Formula,System,Record ID,Text';
            OptionMembers = Value,Caption,Formula,System,"Record ID",Text;
        }
        field(5; "Table No."; Integer)
        {
            Caption = 'Table No.';
        }
        field(6; "Table Name"; Text[30])
        {
            CalcFormula = lookup(AllObjWithCaption."Object Name" where("Object Type" = const(Table),
                                                                        "Object ID" = field("Table No.")));
            Caption = 'Table Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7; "Field No."; Integer)
        {
            Caption = 'Field No.';
            NotBlank = true;
        }
        field(8; "Field Name"; Text[30])
        {
            CalcFormula = lookup(Field.FieldName where(TableNo = field("Table No."),
                                                        "No." = field("Field No.")));
            Caption = 'Field Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(9; Variable; Text[20])
        {
            Caption = 'Variable';
        }
        field(10; "Format String"; Text[100])
        {
            Caption = 'Format String';
        }
        field(12; "Last Record"; Boolean)
        {
            Caption = 'Last Record';
        }
        field(13; Formula; Text[250])
        {
            Caption = 'Formula';

            trigger OnValidate()
            begin
                if Formula <> '' then
                    TestField(Type, Type::Formula);
            end;
        }
        field(14; "System Value"; Option)
        {
            Caption = 'System Value';
            OptionCaption = ' ,User ID,Today,Workdate,User Language,Time,Company Name';
            OptionMembers = " ","User ID",Today,Workdate,"User Language",Time,"Company Name";
        }
        field(15; Text; Text[250])
        {
            Caption = 'Text';

            trigger OnValidate()
            begin
                if Formula <> '' then
                    TestField(Type, Type::Text);
            end;
        }
        field(50; "No. of Filters"; Integer)
        {
            CalcFormula = count("DC - Document Layout Filter" where("Layout No." = field("Layout No."),
                                                                     "Layout Line No." = field("Layout Line No."),
                                                                     "Layout Criteria Line No." = const(0),
                                                                     "Layout Field Line No." = const(0),
                                                                     "Layout Variable Line No." = field("Line No."),
                                                                     "Layout Codeunit Line No." = const(0)));
            Caption = 'No. of Filters';
            Editable = false;
            FieldClass = FlowField;
        }
        field(51; "No. of Criterias"; Integer)
        {
            CalcFormula = count("DC - Document Layout Criterion" where("Layout No." = field("Layout No."),
                                                                        "Layout Line No." = field("Layout Line No."),
                                                                        "Layout Field Line No." = const(0),
                                                                        "Layout Variable Line No." = field("Line No."),
                                                                        "Layout Codeunit Line No." = const(0)));
            Caption = 'No. of Criteria';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Layout No.", "Layout Line No.", "Line No.")
        {
            Clustered = true;
        }
    }

    procedure Caption(): Text[120]
    begin
    end;

    procedure IsNumeric(): Boolean
    begin
    end;
}