"use client";


export const FunctionSelector = () => {
    return (
        <div className="flex flex-col gap-1.5 w-full">
            <div className="flex items-center ml-2">
                <span className="text-xs font-medium mr-2 leading-none">funcName</span>
                <span className="block text-xs font-extralight leading-none">string</span></div>
            <div className="flex border-2 border-base-300 bg-base-200 rounded-full text-accent ">
                <input className="input input-ghost focus-within:border-transparent focus:outline-none focus:bg-transparent focus:text-gray-400 h-[2.2rem] min-h-[2.2rem] px-4 border w-full font-medium placeholder:text-accent/50 text-gray-400" placeholder="string funcName" value="" name="getHash_funcName_string_string" />
            </div>
        </div>
    );
};
