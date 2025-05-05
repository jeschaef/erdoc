import { memo } from "react";
import NodeHandles from "./NodeHandles";

const DefaultMultiValuedEntity = ({
  data,
}: {
  data: {
    label: string;
    isKey: boolean;
    entityIsWeak?: boolean;
    erId?: string;
  };
}) => {
  return (
    <>
      {/* Double border effect for multivalued entity */}
      <div className="relative flex min-h-[80px] min-w-[120px] items-center justify-center rounded-[50%]">
        {/* Outer border - similar to regular entity but with double effect */}
        <div
          className={`absolute inset-0 ${
            data.isKey
              ? "rounded-[50%] border-[5px] border-double"
              : "rounded-[50%] border-2"
          } border-yellow-700 bg-yellow-200`}
        ></div>

        {/* Inner border - creates the double border effect */}
        <div className="absolute inset-4 flex items-center justify-center rounded-[50%] border-2 border-yellow-700 bg-yellow-200">
          <div className="z-10 p-4 text-center">{data.label}</div>
        </div>
      </div>
      <NodeHandles
        TopHandleStyle={[
          { top: "1%" },
          { top: "1%", left: "2%" },
          { top: "1%", left: "25%" },
          { top: "1%", left: "75%" },
          { top: "1%", left: "98%" },
        ]}
        BottomHandleStyle={[
          { bottom: "1%" },
          { bottom: "1%", left: "2%" },
          { bottom: "1%", left: "25%" },
          { bottom: "1%", left: "75%" },
          { bottom: "1%", left: "98%" },
        ]}
        LeftHandleStyle={[
          { left: "0" },
          { left: "0", top: "2%" },
          { left: "0", top: "25%" },
          { left: "0", top: "75%" },
          { left: "0", top: "98%" },
        ]}
        RightHandleStyle={[
          { right: "0" },
          { right: "0", top: "2%" },
          { right: "0", top: "25%" },
          { right: "0", top: "75%" },
          { right: "0", top: "98%" },
        ]}
        use5PerSide={true}
      />
    </>
  );
};

export default memo(DefaultMultiValuedEntity);
